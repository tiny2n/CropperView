//
//  ViewController.m
//  CropperViewDemo
//
//  Created by 최 중관 on 2014. 7. 20..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "ViewController.h"

#import "CropperView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CropperView * cropperView = [[CropperView alloc] initWithFrame:self.view.bounds];
    [cropperView setImage:[UIImage imageNamed:@"background@2x.png"]];

    [cropperView addCropper:CGRectMake(40, 40, 100, 100)];
    [cropperView addCropper:CGRectMake(150, 150, 100, 100)];
    [self.view addSubview:cropperView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
