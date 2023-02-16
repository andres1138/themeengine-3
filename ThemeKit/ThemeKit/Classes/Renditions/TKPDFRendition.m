//
//  TKPDFRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKPDFRendition.h"
#import "TKRendition+Private.h"

@import PDFKit;

@interface TKPDFRendition ()
@end

static const void *TKPDFRenditionRawDataChangedContext = &TKPDFRenditionRawDataChangedContext;

@implementation TKPDFRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:csiData key:key])) {
        self.pdf = [[NSPDFImageRep alloc] initWithData:self.rawData];
        NSImage *i = [[NSImage alloc] init];
        [i addRepresentation:self.pdf];
        
        NSRect r = NSMakeRect(0, 0, self.pdf.size.width, self.pdf.size.height);
        CGImageRef img = [i CGImageForProposedRect:&r context:nil hints:nil];
        _image = [[NSBitmapImageRep alloc] initWithCGImage:img];
        
        CGPDFDocumentRef *pdf = TKIvarPointer(rendition, "_pdfDocument");
        if (pdf != NULL)
            CGPDFDocumentRelease(*pdf);
        
        pdf = NULL;
        self.utiType = (__bridge_transfer NSString *)kUTTypePDF;
    }
    return self;
}

- (NSBitmapImageRep *)image {
    NSImage *i = [[NSImage alloc] init];
    [i addRepresentation:self.pdf];
    
    NSRect r = NSMakeRect(0, 0, self.pdf.size.width, self.pdf.size.height);
    CGImageRef img = [i CGImageForProposedRect:&r context:nil hints:nil];
    return [[NSBitmapImageRep alloc] initWithCGImage:img];
}

- (void)setImage:(NSBitmapImageRep *)image {
    NSImage *i = [[NSImage alloc] init];
    [i addRepresentation:image];
    PDFPage *p = [[PDFPage alloc] initWithImage:i];
    PDFDocument *doc = [[PDFDocument alloc] init];
    [doc insertPage:p atIndex:0];
    self.pdf = [NSPDFImageRep imageRepWithData:doc.dataRepresentation];
    self.rawData = self.pdf.PDFRepresentation;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.rawData) {
        self._previewImage = [[NSImage alloc] init];
        [self._previewImage addRepresentation:self.pdf];
        
        
    } else {
        [super computePreviewImageIfNecessary];
    }
}

@end
