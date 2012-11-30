//
//  TabBarViewController.m
//  iNotice
//
//  Created by zy on 12-11-28.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSThread detachNewThreadSelector:@selector(checkZjuWLan) toTarget:self withObject:nil];

    
}
-(void)checkZjuWLan{
    // jugde network
    if ([[zjuWlanLogin new] judgeLocaton] != UNZJUWLAN && ![[zjuWlanLogin new] isLogin]) {
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
    }

}
-(void)showAlert{
    __block DemoHintView* hintView = [DemoHintView  infoHintView];
    
    // Overwrites the pages titles
    hintView.title = @"求是潮－提示";
    
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithtitle:@"ZJUWLAN" text:@"检测到您已经连接到ZJUWLAN网络，是否登录？" buttonText:@"一键登录" buttonAction:^{
        
        [DemoHintView enableHints:NO];
        [hintView dismiss];
        self.selectedIndex=1;
    }];
    [hintView showInView:self.view orientation:kHintViewOrientationBottom];
}
-(void)viewDidAppear:(BOOL)animated{
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
