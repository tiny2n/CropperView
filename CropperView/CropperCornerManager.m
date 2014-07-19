//
//  CropperCornerManager.m
//
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//


#import "CropperCornerManager.h"

#import "CropperCornerView.h"

static NSUInteger const kCropperConerSize = 22;

@interface CropperCornerManager()
{
    @private
    UIView   * _view;
    NSUInteger _count;
}

@end

@implementation CropperCornerManager

- (id)initWithView:(UIView *)view
{
    if (self = [super init])
    {
        _count = 0;
        _view  = view;
    }
    
    return self;
}

- (void)dealloc
{
    _view = nil;
}

/**
 한 코너 정보 세트를 등록하는 메소드
 @param CGRect
 */
- (void)addCropper:(CGRect)cropper
{
    CGFloat x = CGRectGetMinX(cropper) - (kCropperConerSize / 2);
    CGFloat y = CGRectGetMinY(cropper) - (kCropperConerSize / 2);
    CGFloat width  = x + CGRectGetWidth(cropper);
    CGFloat height = y + CGRectGetHeight(cropper);
    
    // Left & Top corner
    CropperCornerView * LT = [[CropperCornerView alloc] initWithFrame:CGRectMake(x, y, kCropperConerSize, kCropperConerSize)];
    [LT setDelegate:self];
    [LT setTag:_count];
    [LT setCropperCornerMode:CropperCornerModeLeft | CropperCornerModeTop | CropperCornerModeTopLeft];
    [_view addSubview:LT];
    
    // Left & Bottom corner
    CropperCornerView * LB = [[CropperCornerView alloc] initWithFrame:CGRectMake(x, height, kCropperConerSize, kCropperConerSize)];
    [LB setDelegate:self];
    [LB setTag:_count];
    [LB setCropperCornerMode:CropperCornerModeLeft | CropperCornerModeBottom];
    [_view addSubview:LB];
    
    // Right & Top corner
    CropperCornerView * RT = [[CropperCornerView alloc] initWithFrame:CGRectMake(width, y, kCropperConerSize, kCropperConerSize)];
    [RT setDelegate:self];
    [RT setTag:_count];
    [RT setCropperCornerMode:CropperCornerModeRight | CropperCornerModeTop];
    [_view addSubview:RT];
    
    // Right & Bottom corner
    CropperCornerView * RB = [[CropperCornerView alloc] initWithFrame:CGRectMake(width, height, kCropperConerSize, kCropperConerSize)];
    [RB setDelegate:self];
    [RB setTag:_count];
    [RB setCropperCornerMode:CropperCornerModeRight | CropperCornerModeBottom | CropperCornerModeBottomRight];
    [_view addSubview:RB];
    
    _count++;
    
    [self draw];

}

/**
 모든 코너 정보를 제거하는 메소드
 */
- (void)removeAllCroppers
{
    _count = 0;
    
    for (UIView * view in [_view subviews])
    {
        [view removeFromSuperview];
    }

    [self draw];
}

/**
 index에 해당하는 코너 정보를 제거하는 메소드
 @param NSInteger
 */
- (void)removeCropperWithIndex:(NSInteger)index
{
    for (UIView * view in [_view subviews])
    {
        if ([view tag] == index)
        {
            _count--;
            [view removeFromSuperview];
        }
    }
    
    [self draw];
}

/**
 코너 정보를 이용하여 내부 랙트를 그리는 메소드
 */
- (void)draw
{
    [_view setNeedsDisplay];
}

/**
 코너들의 세트 갯수를 반환하는 메소드
 상좌, 상우, 하좌, 하우가 1세트
 @return NSUInteger
 */
- (NSUInteger)count
{
    return _count;
}

/**
 클롭퍼 코너 모드와 인덱스에 맞는 코너 객체 반환하는 메소드
 @param CropperCornerMode
 @param NSInteger
 @return NSArray
 */
- (NSArray *)cropperCornersWithCornerMode:(CropperCornerMode)cropperCornerMode index:(NSInteger)index
{
    NSMutableArray * ret = [NSMutableArray arrayWithCapacity:_count];
    for (UIView * subview in [_view subviews])
    {
        if ([subview isKindOfClass:[CropperCornerView class]])
        {
            CropperCornerView * cropperCornerView = (CropperCornerView *)subview;
            
            if (([cropperCornerView tag] == index) &&                                   // 같은 index
                ([cropperCornerView cropperCornerMode] & cropperCornerMode))            // 같은 corner mode
            {
                [ret addObject:cropperCornerView];
            }
        }
    }
    
    return ret;
}

/**
 인덱스에 맞는 코너 객체들의 frame을 반환하는 메소드
 @param NSUInteger
 @return CGRect
 */
- (CGRect)cropperCornerFrameFromIndex:(NSUInteger)index
{
    CropperCornerView * TL = [self cropperCornersWithCornerMode:CropperCornerModeTopLeft     index:index][0];
    CropperCornerView * BR = [self cropperCornersWithCornerMode:CropperCornerModeBottomRight index:index][0];
    
    return CGRectMake(TL.center.x,
                      TL.center.y,
                      BR.center.x - TL.center.x,
                      BR.center.y - TL.center.y);
}

/**
 포인트를 포함하고 있는 코너의 인덱스를 반환하는 메소드
 @param CGPoint
 @return NSUInteger
 */
- (NSUInteger)cornerIndexFromCGPoint:(CGPoint)point
{
    for (NSUInteger i = 0; i < _count; i++)
    {
        CGRect frame = [self cropperCornerFrameFromIndex:i];
        if (CGRectContainsPoint(frame, point))
        {
            return i;
        }
    }

    return NSUIntegerMax;
}

#pragma mark -
#pragma mark UICropperCornerViewDelegate
- (void)cropperCornerView:(CropperCornerView *)cropperCornerView
{
    NSInteger index = [cropperCornerView tag];
    CropperCornerMode CCM = [cropperCornerView cropperCornerMode];

    // 현재 인덱스 중 코너 모드와 연결된
    // ex,. TL -> BL & TR
    // ex,. BR -> TR & BL
    for (CropperCornerView * CCV in [self cropperCornersWithCornerMode:CCM index:index])
    {
        [CCV setBeganCenter];
    }
}

- (void)cropperCornerView:(CropperCornerView *)cropperCornerView translate:(CGPoint)translate cropperCornerMode:(CropperCornerMode)cropperCornerMode
{
    NSInteger index = [cropperCornerView tag];
    for (CropperCornerView * CCV in [self cropperCornersWithCornerMode:cropperCornerMode index:index])
    {
        [CCV setTranslate:translate cropperCornerMode:cropperCornerMode];
    }

    [self draw];
}


@end
