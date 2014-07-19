//
//  ICropper.h
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 20..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

@protocol ICropper <NSObject>
@required
- (void)addCropper:(CGRect)cropper;
- (void)removeAllCroppers;
- (CGRect)cropperCornerFrameFromIndex:(NSUInteger)index;
- (NSUInteger)count;
@end
