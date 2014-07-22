//
//  CropperView.m
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "CropperView.h"

#import "CropperCornerManager.h"

static NSInteger const kCropperIndexDefault = -1;

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
    
    _contentColor         = [UIColor colorWithWhite:0.0f alpha:0.4f];
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    [self _initialization];
}

- (void)dealloc
{
    _image = nil;
    [self removeAllCroppers];
}

#pragma mark -
#pragma mark ICropper
/**
 코너 정보 세트 추가
 @param CGRect
 */
- (void)addCropper:(CGRect)cropper
{
    [_cropperCornerManager addCropper:cropper];
}

/**
 모든 코너 정보 제거
 */
- (void)removeAllCroppers
{
    [_cropperCornerManager removeAllCroppers];
}

/**
 인덱스에 해당하는 코너들의 Rect를 반환하는 메소드
 @param NSUInteger
 @return CGRect
 */
- (CGRect)cropperCornerFrameFromIndex:(NSUInteger)index
{
    return [_cropperCornerManager cropperCornerFrameFromIndex:index];
}

/**
 코너 세트의 갯수를 반환하는 메소드
 @return NSUInteger
 */
- (NSUInteger)count
{
    return [_cropperCornerManager count];
}

#pragma mark -
#pragma mark crop
/**
 특정 인덱스 코너 세트들을 이용하여 Crop Image를 반환하는 메소드
 @param NSUInteger
 @return UIImage
 */
- (UIImage *)cropAtIndex:(NSUInteger)index
{
    CGSize imageSize = [_image size];
    
    CGRect frame = [self cropperCornerFrameFromIndex:index];
    
    CGFloat scale = imageSize.width / [self bounds].size.width;
    CGRect rect   = frame;
    rect.origin.x    *= scale;
    rect.origin.y    *= scale;
    rect.size.width  *= scale;
    rect.size.height *= scale;

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, CGRectMake(0.0f, 0.0f, CGRectGetWidth(rect), CGRectGetHeight(rect)));
    [_image drawInRect:CGRectMake(-CGRectGetMinX(rect), -CGRectGetMinY(rect), imageSize.width, imageSize.height)];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

/**
 모든 코너 세트들을 이용하여 Crop Image List를 반환하는 메소드
 @return NSArray UIImage List
 */
- (NSArray *)crop
{
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:[self count]];

    for (NSUInteger i = 0, cnt = [self count]; i < cnt; i++)
    {
        [result addObject:[self cropAtIndex:i]];
    }
    
    return result;
}

#pragma mark -
#pragma mark UIGestureRecognizer
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:[sender view]];
    static NSInteger cropperIndex = kCropperIndexDefault;
    
    switch ([sender state])
    {
        case UIGestureRecognizerStateBegan:
        {
            cropperIndex = [_cropperCornerManager cornerIndexFromCGPoint:point];
            
            for (id<ICropperCorner> cropperCorner in [_cropperCornerManager cropperCornersWithCornerMode:CropperCornerModeAll index:cropperIndex])
            {
                // Cropper 전체적으로 이동 준비
                [cropperCorner setBeganCenter];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (cropperIndex == kCropperIndexDefault)
            {
                // cropper index 를 검사하여 Rect 겹치더라도 오류나지 않게 수정
                cropperIndex = [_cropperCornerManager cornerIndexFromCGPoint:point];
            }
            
            CGPoint translate = [sender translationInView:[sender view]];
            for (id<ICropperCorner> cropperCorner in [_cropperCornerManager cropperCornersWithCornerMode:CropperCornerModeAll index:cropperIndex])
            {
                // Cropper 전체적으로 이동
                [_cropperCornerManager cropperCorner:cropperCorner translate:translate cropperCornerMode:CropperCornerModeAll];
            }
            break;
        }
        default:
            cropperIndex = kCropperIndexDefault;
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1. draw Background Image
    CGSize imageSize = [_image size];
    CGSize viewSize  = [self bounds].size;
    
    CGFloat hfactor = imageSize.width  / viewSize.width;
    CGFloat vfactor = imageSize.height / viewSize.height;
    
    CGFloat factor  = fmax(hfactor, vfactor);
    
    CGFloat newWidth  = imageSize.width  / factor;
    CGFloat newHeight = imageSize.height / factor;
    
    CGFloat x = (viewSize.width  - newWidth)  / 2;
    CGFloat y = (viewSize.height - newHeight) / 2;
    CGRect newRect = CGRectMake(x, y, newWidth, newHeight);
    
    [_image drawInRect:newRect];
    
    // 2. draw Cropper Areas
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _contentColor.CGColor);
    
    for (NSUInteger i = 0; i < [_cropperCornerManager count]; i++)
    {
        CGRect frame = [_cropperCornerManager cropperCornerFrameFromIndex:i];
        CGContextAddRect(context, frame);
    };

    CGContextFillPath(context);
}

@end
