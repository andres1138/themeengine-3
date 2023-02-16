//
//  TKSVGRendition.m
//  ThemeKit
//
//  Created by Jeremy on 9/5/20.
//  Copyright © 2020 Alex Zielenski. All rights reserved.
//

#import "TKSVGRendition.h"
#import "TKRendition+Private.h"
#import <SymRez/SymRez.h>
#import <CoreUI/Renditions/_CUIThemeSVGRendition.h>
#import <objc/objc-runtime.h>
#import <dlfcn.h>

extern void CGSVGDocumentRelease(CGSVGDocumentRef);
void (*TKCGSVGDocumentWriteToData)(CGSVGDocumentRef, CFDataRef, CFDictionaryRef);
CGSVGDocumentRef (*TKCGSVGDocumentCreateFromData)(CFDataRef, CFDictionaryRef);


/* Not exported
@interface _NSSVGImageRep : NSImageRep {

    CGSVGDocumentRef _document;

}
-(id)initWithSVGDocument:(CGSVGDocumentRef)arg1 ;
-(id)initWithCoder:(id)arg1 ;
-(void)dealloc;
-(void)encodeWithCoder:(id)arg1 ;
-(id)initWithData:(id)arg1 ;
-(char)draw;
@end
 */

@interface TKSVGRendition ()
@property CGSVGDocumentRef svgDocument;
@end

@implementation TKSVGRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:csiData key:key])) {
        self.svgDocument = ((CGSVGDocumentRef (*)(id, SEL)) objc_msgSend)(rendition, sel_getUid("svgDocument"));
        CFMutableDataRef svgData = (__bridge CFMutableDataRef)([NSMutableData data]);
        TKCGSVGDocumentWriteToData(self.svgDocument, svgData, NULL);
        _rawData = (__bridge NSData *)(svgData);
        self.utiType = (__bridge_transfer NSString *)kUTTypeScalableVectorGraphics;
    }
    return self;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    id svgImageRep = ((id (*)(id, SEL))objc_msgSend)(objc_lookUpClass("_NSSVGImageRep"), sel_getUid("alloc"));
    id rep = ((id (*)(id, SEL, CGSVGDocumentRef))objc_msgSend)(svgImageRep, sel_getUid("initWithSVGDocument:"), self.svgDocument);
    self._previewImage = [[NSImage alloc] init];
    [self._previewImage addRepresentation:rep];
}

- (void)setRawData:(NSData *)rawData {
    [self willChangeValueForKey:@"rawData"];
    _rawData = rawData;
    self.svgDocument = TKCGSVGDocumentCreateFromData((__bridge CFDataRef)rawData, nil);
    self._previewImage = nil;
    [self didChangeValueForKey:@"rawData"];
}

+ (NSSet *)keyPathsForValuesAffectingRawData {
    return [NSSet setWithObject:@"svg"];
}

- (CSIGenerator *)generator {
    CSIGenerator *generator = [[CSIGenerator alloc] initWithRawData:_rawData
                                                        pixelFormat:self.pixelFormat
                                                             layout:self.layout];
    
    return generator;
}

+ (void)load {
    TKCGSVGDocumentWriteToData = dlsym(RTLD_DEFAULT, "CGSVGDocumentWriteToData");
    TKCGSVGDocumentCreateFromData = dlsym(RTLD_DEFAULT, "CGSVGDocumentCreateFromData");
}

@end
