//
//  CropperCornerManager.h
//
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "CropperCornerView.h"

@protocol ICropperCornerManager <NSObject, CropperCornerViewDelegate>
@required
- (NSArray *)cropperCornersWithCornerMode:(CropperCornerMode)cropperCornerMode index:(NSInteger)index;

- (CGRect)cropperCornerFrameFromIndex:(NSUInteger)index;
- (NSUInteger)cornerIndexFromCGPoint:(CGPoint)point;

- (void)addCropper:(CGRect)cropper;
- (void)removeAllCroppers;
- (void)draw;
- (NSUInteger)count;

@end

@interface CropperCornerManager : NSObject <ICropperCornerManager>

- (id)initWithView:(UIView *)view;

@end
