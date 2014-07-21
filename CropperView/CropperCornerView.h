//
//  CropperCornerView.h
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "ICropperCorner.h"

@protocol CropperCornerViewDelegate;

@interface CropperCornerView : UIView <ICropperCorner>

@property (nonatomic, weak) id<CropperCornerViewDelegate> delegate;

@end

@protocol CropperCornerViewDelegate<NSObject>
@required
- (void)cropperCorner:(id<ICropperCorner>)cropperCorner;
- (void)cropperCorner:(id<ICropperCorner>)cropperCorner translate:(CGPoint)translate cropperCornerMode:(CropperCornerMode)cropperCornerMode;
@end


