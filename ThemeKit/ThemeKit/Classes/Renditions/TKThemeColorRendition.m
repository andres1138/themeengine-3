//
//  TKThemeColorRendition.m
//  ThemeKit
//
//  Created by Jeremy on 1/17/22.
//  Copyright © 2022 Alex Zielenski. All rights reserved.
//

#import "TKThemeColorRendition.h"
#import "TKRendition+Private.h"
#import <CoreUI/Renditions/_CUIThemeColorRendition.h>

@interface TKThemeColorRendition ()
@property (strong) NSMutableData *csiData;
@property csicolor *csiColor;
@end

@implementation TKThemeColorRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData  key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:(NSData *)csiData key:key])) {
        self.csiData = [csiData mutableCopy];
        _csiColor = memmem(_csiData.bytes, _csiData.length, "RLOC", 4);
        CGColorRef cgColor = [(_CUIThemeColorRendition*)rendition cgColor];
        self.color = [NSColor colorWithCGColor:cgColor];
    }
    
    return self;
}

- (void)commitToStorage {
    _csiColor->red = self.color.redComponent;
    _csiColor->green = self.color.greenComponent;
    _csiColor->blue = self.color.blueComponent;
    _csiColor->alpha = self.color.alphaComponent;
    
    [self.cuiAssetStorage setAsset:_csiData forKey:self.keyData];
}

- (void)removeFromStorage {
    [(TKRendition*)self removeFromStorage];
}

- (NSString *)renditionHash {
   return [(TKRendition*)self renditionHash];
}

@end
