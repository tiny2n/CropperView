//
//  CropperView.m
//
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

@class CropperCornerView;

@protocol ICropperView <NSObject>
@required
- (void)addCropper:(CGRect)cropper;
- (void)removeAllCroppers;
@end

@interface CropperView : UIView <ICropperView>

@property (nonatomic, strong) UIColor * contentColor;

@end
