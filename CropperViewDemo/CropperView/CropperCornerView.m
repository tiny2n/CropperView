//
//  CropperCornerView.m
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "CropperCornerView.h"

@interface CropperCornerView()
{
    @private
    CGPoint _beganCenter;
}
@end

@implementation CropperCornerView

- (void)_initialization
{
    _cropperCornerMode = CropperCornerModeNone;
    
    [self setImage:[UIImage imageNamed:@"CropperCornerView.png"]];
    [self setUserInteractionEnabled:YES];
    
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

}

- (void)setBeganCenter
{
    _beganCenter = [self center];
}

- (void)setTranslate:(CGPoint)translate cropperCornerMode:(CropperCornerMode)cropperCornerMode
{
    // ex,. 우측 & 아래 움직일땐 ...
    // 우축 & 위   ... Y 고정
    // 좌측 & 아래  ... X 고정
    // 좌측 & 위   ... X, Y고정
    CGPoint newPoint = _beganCenter;
    
    if ((_cropperCornerMode & cropperCornerMode & CropperCornerModeLeft) ||
        (_cropperCornerMode & cropperCornerMode & CropperCornerModeRight))
    {
        newPoint.x += translate.x;
    }
    
    if ((_cropperCornerMode & cropperCornerMode & CropperCornerModeTop)  ||
        (_cropperCornerMode & cropperCornerMode & CropperCornerModeBottom))
    {
        newPoint.y += translate.y;
    }
    
    [self setCenter:newPoint];
}

#pragma mark -
#pragma mark UIPanGestureRecognizer
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    switch (panGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if ([_delegate respondsToSelector:@selector(cropperCornerView:)])
            {
                // began center
                [_delegate cropperCornerView:self];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translate = [panGestureRecognizer translationInView:[panGestureRecognizer view]];
            if ([_delegate respondsToSelector:@selector(cropperCornerView:translate:cropperCornerMode:)])
            {
                // translate
                [_delegate cropperCornerView:self translate:translate cropperCornerMode:[self cropperCornerMode]];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        default:
            _beganCenter = CGPointZero;
            break;
    }
}

@end
