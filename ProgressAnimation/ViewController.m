//
//  ViewController.m
//  ProgressAnimation
//
//  Created by MaRui on 16/7/18.
//  Copyright © 2016年 MaRui. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ProgressView *proView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) setProgress:0.75 Duration:0.7*5];
    proView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.view addSubview:proView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
