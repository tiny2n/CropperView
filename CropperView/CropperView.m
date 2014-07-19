//
//  CropperView.m
//
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "CropperView.h"

#import "CropperCornerManager.h"

@interface CropperView()
{
    @private
    id<ICropperCornerManager> _cropperCornerManager;
}

@end

@implementation CropperView

- (void)_initialization
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    _contentColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    _cropperCornerManager = [[CropperCornerManager alloc] initWithView:self];
    
    // add GestureRecognizer
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark -
#pragma mark life-cycle
- (id)init
{
    if (self = [super init])
    {
        // Initialization code
        [self _initialization];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        [self _initialization];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // Initialization code
        [self _initialization];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeAllCroppers];
}

- (void)addCropper:(CGRect)cropper
{
    // 코너 정보 세트 추가
    [_cropperCornerManager addCropper:cropper];
}

- (void)removeAllCroppers
{
    // 모든 코너 정보 제거
    [_cropperCornerManager removeAllCroppers];
}

#pragma mark -
#pragma mark UIGestureRecognizer
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point   = [panGestureRecognizer locationInView:[panGestureRecognizer view]];
    NSInteger index = [_cropperCornerManager cornerIndexFromCGPoint:point];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        for (CropperCornerView * cropperCornerView in [_cropperCornerManager cropperCornersWithCornerMode:CropperCornerModeAll index:index])
        {
            // frame 전체적으로 이동 준비
            [cropperCornerView setBeganCenter];
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [panGestureRecognizer translationInView:[panGestureRecognizer view]];
        for (CropperCornerView * cropperCornerView in [_cropperCornerManager cropperCornersWithCornerMode:CropperCornerModeAll index:index])
        {
            // frame 전체적으로 이동
            [_cropperCornerManager cropperCornerView:cropperCornerView translate:translate cropperCornerMode:CropperCornerModeAll];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Fill black
    CGContextSetFillColorWithColor(context, _contentColor.CGColor);
    
    for (NSUInteger i = 0; i < [_cropperCornerManager count]; i++)
    {
        CGRect frame = [_cropperCornerManager cropperCornerFrameFromIndex:i];
        CGContextAddRect(context, frame);
    };

    CGContextFillPath(context);
}

@end
