/*
                       * This header is generated by classdump-dyld 0.7
                       * on Sunday, December 26, 2021 at 5:40:17 PM Eastern Standard Time
                       * Operating System: Version 12.2 (Build 21D5025f)
                       * Image Source: /System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/CoreUI
                       * classdump-dyld is licensed under GPLv3, Copyright © 2013 by Elias Limneos.
                       */

#import <CoreUI/CUIThemeRendition.h>

@class NSString;

@interface _CUIThemeColorRendition : CUIThemeRendition {

	CGColorRef _cgColor;
	csicolor * _csiColor;
	NSString* _colorName;

}

-(CGColorRef)cgColor;
-(BOOL)substituteWithSystemColor;
-(CGColorSpaceRef)_colorSpaceWithID:(int)ID;
-(NSString *)systemColorName;
-(csicolor *)csiColor;
@end

