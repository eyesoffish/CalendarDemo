//
//  ViewController.m
//  CalendarDemo
//
//  Created by zoulin on 15/12/29.
//  Copyright © 2015年 miki. All rights reserved.
//

#import "ViewController.h"
#import "CalenderView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //调用方式
    CalenderView *caleView = [[CalenderView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 250)];
    caleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:caleView];
}

@end
