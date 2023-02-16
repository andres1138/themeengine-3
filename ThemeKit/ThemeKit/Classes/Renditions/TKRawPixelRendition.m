//
//  TKRawPixelRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 7/6/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRawPixelRendition.h"
#import "TKRendition+Private.h"

@interface TKRawPixelRendition ()
@end

@implementation TKRawPixelRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:csiData key:key])) {
        
        self.csiData = [csiData mutableCopy];
        
        unsigned int listOffset = offsetof(struct csiheader, infolistLength);
        unsigned int listLength = 0;
        [csiData getBytes:&listLength range:NSMakeRange(listOffset, sizeof(listLength))];
        listOffset += listLength + sizeof(unsigned int) * 4;
        
        unsigned int type = 0;
        [csiData getBytes:&type range:NSMakeRange(listOffset, sizeof(type))];
        
        listOffset += 8;
        unsigned int dataLength = 0;
        [csiData getBytes:&dataLength range:NSMakeRange(listOffset, sizeof(dataLength))];
        
        listOffset += sizeof(dataLength);
        self.rawData = [csiData subdataWithRange:NSMakeRange(listOffset, dataLength)];
        
        _image = [[NSBitmapImageRep alloc] initWithData:self.rawData];
    }
    
    return self;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.image) {
        // Just get the image of the rendition
        self._previewImage = [[NSImage alloc] initWithSize:self.image.size];
        [self._previewImage addRepresentation:self.image];
    }
}

- (void)setImage:(NSBitmapImageRep *)image {
    [super setImage:image];
    
    if (self.pixelFormat == 'JPEG') {
        NSData *jpegData = [self.image representationUsingType:NSBitmapImageFileTypeJPEG properties:[NSDictionary dictionary]];

        const void *csiData = self.csiData.bytes;
        struct csiheader *csiHeader = (struct csiheader*)csiData;
        struct CUIRawPixelRendition *rawPix = (struct CUIRawPixelRendition *)(csiData + sizeof(struct csiheader) + csiHeader->infolistLength);
        
        float compressionFactor = (rawPix->rawDataLength) / jpegData.length;
        jpegData = [self.image representationUsingType:NSBitmapImageFileTypeJPEG properties:
                    [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:compressionFactor] forKey:NSImageCompressionFactor]];
        
        self.rawData = [self.image representationUsingType:NSBitmapImageFileTypeJPEG properties:[NSDictionary dictionary]];
    }
}

- (void)commitToStorage {
    void *csiData = self.csiData.mutableBytes;
    struct csiheader *csiHeader = (struct csiheader*)csiData;
    struct CUIRawPixelRendition *rawPix = (struct CUIRawPixelRendition *)(csiData + sizeof(struct csiheader) + csiHeader->infolistLength);
    
    csiHeader->bitmaps.payloadSize = ((unsigned int)self.rawData.length + sizeof(struct CUIRawPixelRendition));
    rawPix->rawDataLength = (uint32_t)self.rawData.length;
    
    NSMutableData *finalCsiData = [NSMutableData dataWithBytes:csiData
                                                        length:sizeof(struct csiheader) +
                                                                csiHeader->infolistLength +
                                                                sizeof(struct CUIRawPixelRendition)];
    [finalCsiData appendBytes:self.rawData.bytes length:self.rawData.length];
    
    [self.cuiAssetStorage setAsset:finalCsiData forKey:self.keyData];
}

@end
