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
    [cropperView addCropper:CGRectMake(10, 10, 100, 100)];
    [cropperView addCropper:CGRectMake(130, 130, 100, 100)];
    [self.view addSubview:cropperView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
