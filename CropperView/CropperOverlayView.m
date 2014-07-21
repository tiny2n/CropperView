//
//  CropperOverlayView.m
//  CropperViewDemo
//
//  Created by 최 중관 on 2014. 7. 21..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "CropperOverlayView.h"

@interface CropperOverlayView()
{
    @private
}

@end

@implementation CropperOverlayView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill black
    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);

//    for (NSUInteger i = 0; i < [_cropperCornerManager count]; i++)
//    {
//    CGRect frame = [_cropperCornerManager cropperCornerFrameFromIndex:i];
    CGRect frame = CGRectMake(100, 200, 100, 100);
    CGContextAddRect(context, frame);
//    };

    CGContextFillPath(context);
}

@end
