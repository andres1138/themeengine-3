//
//  TKSVGRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Jeremy on 9/10/20.
//  Copyright © 2020 Alex Zielenski. All rights reserved.
//

#import "TKSVGRendition+Pasteboard.h"
NSString *const TESVGPasteboardType = @"com.alexzielenski.themekit.rendition.svg";

@implementation TKSVGRendition (Pasteboard)
- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    
    return [[super writableTypesForPasteboard:pasteboard] arrayByAddingObjectsFromArray:
            @[
              self.mainDataType
              ]];
}

- (NSArray *)readableTypes {
    return [[super readableTypes] arrayByAddingObjectsFromArray:@[
                                                                  self.mainDataType,
                                                                  (__bridge NSString *)kUTTypeFileURL,
                                                                  (__bridge NSString *)kUTTypeURL
                                                                  ]];
}

- (NSString *)mainDataType {
    return self.utiType;
}

- (NSString *)mainDataExtension {
   if ([self.mainDataType isEqualToString:TKUTITypeCoreAnimationArchive])
       return @"caar";
    return [super mainDataExtension];
}

- (id)pasteboardPropertyListForType:(nonnull NSString *)type {
    if ([type isEqualToString:self.mainDataType] || [type isEqualToString:TESVGPasteboardType]) {
        return self.rawData;
    }
    
    return [super pasteboardPropertyListForType:type];
}

- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item {
    NSString *available = [item availableTypeFromArray:@[ TESVGPasteboardType, self.mainDataType, (__bridge NSString *)kUTTypeURL, (__bridge NSString *)kUTTypeFileURL ]];
    if (available != nil) {
        NSData *data = NULL;
        if ([available isEqualToString:(__bridge NSString *)kUTTypeURL] ||
                   [available isEqualToString:(__bridge NSString *)kUTTypeFileURL]) {

            NSString *str = [item stringForType:available];
            NSURL *fileURL = [NSURL URLWithString:str];
            if(![fileURL.pathExtension.lowercaseString isEqualToString:@"svg"])
                return NO;
            
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            if (data) {
                self.rawData = data;
                return YES;
            }
        }
    }
    
    return NO;
}

+ (NSString *)pasteboardType {
    return TESVGPasteboardType;
}

@end
