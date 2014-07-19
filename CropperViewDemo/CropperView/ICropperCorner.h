//
//  ICropperCorner.h
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 20..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CropperCornerMode) {
    CropperCornerModeNone           = 0,
    CropperCornerModeLeft           = 1 << 0,
    CropperCornerModeRight          = 1 << 1,
    CropperCornerModeTop            = 1 << 2,
    CropperCornerModeBottom         = 1 << 3,
    CropperCornerModeTopLeft        = 1 << 4,
    CropperCornerModeBottomRight    = 1 << 5,
    CropperCornerModeAll            = CropperCornerModeLeft | CropperCornerModeRight | CropperCornerModeTop | CropperCornerModeBottom
};

@protocol ICropperCorner <NSObject>
@required
@property (nonatomic, assign) CropperCornerMode cropperCornerMode;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGPoint center;

- (void)setBeganCenter;
- (void)setTranslate:(CGPoint)translate cropperCornerMode:(CropperCornerMode)cropperCornerMode;
@end
