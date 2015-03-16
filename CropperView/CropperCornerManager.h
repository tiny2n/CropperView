//
//  CropperCornerManager.h
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "CropperCornerView.h"

#import "ICropper.h"

@protocol ICropperCornerManager <ICropper, CropperCornerViewDelegate>
@required
- (BOOL)hasCropperCornersWithCornerMode:(CropperCornerMode)cropperCornerMode index:(NSInteger)index;
- (NSArray *)cropperCornersWithCornerMode:(CropperCornerMode)cropperCornerMode index:(NSInteger)index;
- (NSUInteger)cornerIndexFromCGPoint:(CGPoint)point;
@end

@interface CropperCornerManager : NSObject <ICropperCornerManager>

- (instancetype)initWithView:(UIView *)view;

@end
