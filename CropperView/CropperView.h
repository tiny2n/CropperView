//
//  CropperView.m
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "ICropper.h"

@interface CropperView : UIView <ICropper>

@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) UIColor * contentColor;

- (UIImage *)cropAtIndex:(NSUInteger)index;
- (NSArray *)crop;

@end
