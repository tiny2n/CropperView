//
//  CropperCornerManager.m
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//


#import "CropperCornerManager.h"

#import "CropperCornerView.h"

static NSUInteger const kCropperConerSize = 22; // 코너 이미지 사이즈

@interface CropperCornerManager()
{
    @private
    __weak UIView   * _view;
    NSUInteger _count;
}

@end

@implementation CropperCornerManager

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"You must call select that initWithView:"
                                 userInfo:nil];
}

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
    
    
    CropperCornerView * LT = [[CropperCornerView alloc] initWithFrame:CGRectMake(x,     y,      kCropperConerSize, kCropperConerSize)];         // Left & Top corner
    CropperCornerView * LB = [[CropperCornerView alloc] initWithFrame:CGRectMake(x,     height, kCropperConerSize, kCropperConerSize)];         // Left & Bottom corner
    CropperCornerView * RT = [[CropperCornerView alloc] initWithFrame:CGRectMake(width, y,      kCropperConerSize, kCropperConerSize)];         // Right & Top corner
    CropperCornerView * RB = [[CropperCornerView alloc] initWithFrame:CGRectMake(width, height, kCropperConerSize, kCropperConerSize)];         // Right & Bottom corner
    
    [LT setDelegate:self];
    [LB setDelegate:self];
    [RT setDelegate:self];
    [RB setDelegate:self];
    
    [LT setIndex:_count];
    [LB setIndex:_count];
    [RT setIndex:_count];
    [RB setIndex:_count];
    
    [LT setCropperCornerMode:CropperCornerModeLeft  | CropperCornerModeTop      | CropperCornerModeTopLeft      ];  // 크기를 구하기 위해 좌상단 플래그 추가 등록
    [LB setCropperCornerMode:CropperCornerModeLeft  | CropperCornerModeBottom                                   ];
    [RT setCropperCornerMode:CropperCornerModeRight | CropperCornerModeTop                                      ];
    [RB setCropperCornerMode:CropperCornerModeRight | CropperCornerModeBottom   | CropperCornerModeBottomRight  ];  // 크기를 구하기 위해 우하단 플래그 추가 등록

    [_view addSubview:LT];
    [_view addSubview:LB];
    [_view addSubview:RT];
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
 특정 인덱스에 해당하는 코너 정보의 존재를 반환하는 메소드
 @param CropperCornerMode
 @param NSInteger
 @return BOOL
 */
- (BOOL)hasCropperCornersWithCornerMode:(CropperCornerMode)cropperCornerMode index:(NSInteger)index
{
    for (UIView * subview in [_view subviews])
    {
        if ([subview conformsToProtocol:@protocol(ICropperCorner)])
        {
            id<ICropperCorner> cropperCorner = (id<ICropperCorner>)subview;
            
            if (([cropperCorner index] == index) &&                             // 같은 index
                ([cropperCorner cropperCornerMode] & cropperCornerMode))        // 같은 corner mode
            {
                return YES;
            }
        }
    }
    
    return NO;
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
        if ([subview conformsToProtocol:@protocol(ICropperCorner)])
        {
            id<ICropperCorner> cropperCorner = (id<ICropperCorner>)subview;
            
            if (([cropperCorner index] == index) &&                             // 같은 index
                ([cropperCorner cropperCornerMode] & cropperCornerMode))        // 같은 corner mode
            {
                [ret addObject:cropperCorner];
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
    if (![self hasCropperCornersWithCornerMode:CropperCornerModeTopLeft     index:index]) return CGRectZero;
    if (![self hasCropperCornersWithCornerMode:CropperCornerModeBottomRight index:index]) return CGRectZero;
    
    id<ICropperCorner> TL = [self cropperCornersWithCornerMode:CropperCornerModeTopLeft     index:index][0];
    id<ICropperCorner> BR = [self cropperCornersWithCornerMode:CropperCornerModeBottomRight index:index][0];
    
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

    return -1;
}

#pragma mark -
#pragma mark UICropperCornerViewDelegate
- (void)cropperCorner:(id<ICropperCorner>)cropperCorner
{
    NSInteger index = [cropperCorner index];
    CropperCornerMode CCM = [cropperCorner cropperCornerMode];

    // 현재 인덱스 중 코너 모드와 연결된
    // ex,. TL -> BL & TR
    // ex,. BR -> TR & BL
    for (id<ICropperCorner> cropperCorner in [self cropperCornersWithCornerMode:CCM index:index])
    {
        [cropperCorner setBeganCenter];
    }
}

- (void)cropperCorner:(id<ICropperCorner>)cropperCorner translate:(CGPoint)translate cropperCornerMode:(CropperCornerMode)cropperCornerMode
{
    NSInteger index = [cropperCorner index];
    for (id<ICropperCorner> cropperCorner in [self cropperCornersWithCornerMode:cropperCornerMode index:index])
    {
        [cropperCorner setTranslate:translate cropperCornerMode:cropperCornerMode];
    }

    [self draw];
}


@end
