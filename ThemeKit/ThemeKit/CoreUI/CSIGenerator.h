/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import <Foundation/Foundation.h>
#import <CoreUI/CSIBitmapWrapper.h>

@class CUIPSDGradient, CUIShapeEffectPreset;
@interface CSIGenerator : NSObject
{
    NSMutableArray *_slices; // 0x0
    NSMutableArray *_bitmaps; // 0x8
    NSMutableArray *_metrics; // 0x10
    BOOL _allowsMultiPassEncoding; // 0x18
    short _layout; // 0x20
    NSData *_rawData; // 0x28
    int _exifOrientation; // 0x30
    unsigned long long _rowbytes; // 0x38
    NSString *_assetPackIdentifier; // 0x40
    NSSet *_externalTags; // 0x48
    CGRect _externalReferenceFrame; // 0x50
    unsigned short _linkLayout; // 0x58
}

+ (int)fileEncoding;
+ (void)setFileEncoding:(int)arg1;

@property(nonatomic) BOOL allowsMultiPassEncoding; // @synthesize allowsMultiPassEncoding=_allowsMultiPassEncoding;
@property(nonatomic) CGRect alphaCroppedFrame; // @synthesize alphaCroppedFrame=_alphaCroppedFrame;
@property(nonatomic) CGSize originalUncroppedSize; // @synthesize originalUncroppedSize=_originalUncroppedSize;
@property(nonatomic) TKEXIFOrientation exifOrientation; // @synthesize exifOrientation=_exifOrientation;
@property(copy, nonatomic) NSDate *modtime; // @synthesize modtime=_modtime;
@property(nonatomic) CGFloat opacity; // @synthesize opacity=_opacity;
@property(nonatomic) CGBlendMode blendMode; // @synthesize blendMode=_blendMode;
@property(retain, nonatomic) CUIShapeEffectPreset *effectPreset; // @synthesize effectPreset=_effectPreset;
@property(readonly, nonatomic) NSArray *references; // @synthesize references=_references;
@property(nonatomic) CSIPixelFormat pixelFormat; // @synthesize pixelFormat=_pixelFormat;
@property(nonatomic) unsigned int scaleFactor; // @synthesize scaleFactor=_scaleFactor;
@property(retain, nonatomic) CUIPSDGradient *gradient; // @synthesize gradient=_gradient;
@property(nonatomic) short colorSpaceID; // @synthesize colorSpaceID=_colorSpaceID;
@property(nonatomic, getter=isExcludedFromContrastFilter) BOOL excludedFromContrastFilter; // @synthesize excludedFromContrastFilter=_isExcludedFromFilter;
@property(nonatomic) CoreThemeTemplateRenderingMode templateRenderingMode; // @synthesize templateRenderingMode=_templateRenderingMode;
@property(nonatomic) BOOL isVectorBased; // @synthesize isVectorBased=_isVectorBased;
@property(nonatomic) BOOL isRenditionFPO; // @synthesize isRenditionFPO=_isFPOHint;
@property(copy, nonatomic) NSString *utiType; // @synthesize utiType=_utiType;
@property(copy, nonatomic) NSString *name; // @synthesize name=_name;
@property(readonly, nonatomic) CGSize size; // @synthesize size=_size;

- (instancetype)initWithInternalReferenceRect:(CGRect)arg1 layout:(short)arg2;
- (instancetype)initWithLayerStackData:(id)arg1 withCanvasSize:(struct CGSize)arg2;
- (instancetype)initWithExternalReference:(id)arg1 tags:(id)arg2;
- (instancetype)initWithRawData:(NSData *)arg1 pixelFormat:(CSIPixelFormat)arg2 layout:(short)arg3;
- (instancetype)initWithShapeEffectPreset:(CUIShapeEffectPreset *)arg1 forScaleFactor:(unsigned int)arg2;
- (instancetype)initWithCanvasSize:(CGSize)arg1 sliceCount:(unsigned int)arg2 layout:(short)arg3;

- (NSData *)CSIRepresentationWithCompression:(BOOL)compress;
- (void)setCompressionType:(unsigned long long)type;
- (unsigned long long)compressionType;

- (void)addLayerReference:(id)arg1;
- (void)addMetrics:(CUIMetrics)arg1;
- (void)addSliceRect:(CGRect)sliceRect;
- (void)addBitmap:(CSIBitmapWrapper *)wrapper;

//! Don't use these:
- (unsigned long long)writeExternalLinkToData:(NSData *)data;
- (unsigned long long)writeRawDataToData:(NSData *)data;
- (unsigned long long)writeGradientToData:(NSData *)data;
//- (void)_addNodes:(id)arg1 toNodeList:(struct _csigradientdatanode *)arg2;
- (unsigned long long)writeBitmap:(id)arg1 toData:(NSData *)data compress:(BOOL)compress;
- (unsigned long long)writeResourcesToData:(id)arg1;

- (void)writeHeader:(struct csiheader *)header toData:(NSData *)data;
- (void)formatCSIHeader:(struct csiheader *)header;

@end
