//
//  TKIconRendition.m
//  ThemeKit
//
//  Created by Jeremy on 12/26/21.
//  Copyright © 2021 Alex Zielenski. All rights reserved.
//

#import "TKIconRendition.h"
#import "TKRendition+Private.h"
#import <CoreUI/Renditions/_CUIThemeMultisizeImageSetRendition.h>

@implementation TKIconRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData  key:(CUIRenditionKey *)key {
    
    self = [super _initWithCUIRendition:rendition csiData:(NSData *)csiData key:key];
    return self;
}

@end
