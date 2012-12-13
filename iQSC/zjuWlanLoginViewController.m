//
//  zjuWlanLoginViewController.m
//  iNotice
//
//  Created by zy on 12-11-20.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "zjuWlanLoginViewController.h"
@interface zjuWlanLoginViewController (){
    UIActivityIndicatorView *activityIndicatorView;
     
}

@end

@implementation zjuWlanLoginViewController
@synthesize txtPassWord,txtUserName,aFreshing,btnLogIn,btnLogOut,lblStatus;
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
	// Do any additional setup after loading the view.
    //load userinfo file
    NSLog(@"UI:request userinfo from core");
    NSDictionary *userInfo = [[zjuWlanLogin new] loadInfo];
    if(userInfo){
        txtUserName.text = [userInfo valueForKey:@"zjuUserName"];
        txtPassWord.text = [userInfo valueForKey:@"zjuPassWord"];
        NSLog(@"UI:load sucessfully");
    }
    else{
        NSLog(@"UI:failed to load userinfo");
    }
    		
    //load activityIndicatorView
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(120.f, 48.0f, 37.0f, 37.0f)];
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;//color
    [self.view addSubview : activityIndicatorView] ;
    aFreshing.alpha = 0.0f;
    
    [self startCheckStatus];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    //NSLog(@"UI:checkNework request sent to core.");
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtUserName:nil];
    [self setTxtPassWord:nil];
    [self setAFreshing:nil];
    [self setLblStatus:nil];
    [self setBtnLogIn:nil];
    [self setBtnLogOut:nil];
    [self setLblStatus:nil];
    [super viewDidUnload];
}
- (void)startCheckStatus{
    //lblIsLogin.alpha = 0.0f;
    //lblIsZJuWLAN.alpha = 0.0f;
    if (aFreshing.alpha > 0.1f) {//is freshing?
        return;
    }
    aFreshing.alpha = 1.0f;
    lblStatus.text = TEXT_FRESHING;
    
    //btnLogIn.enabled = NO;
    //btnLogOut.enabled = NO;
    
    [aFreshing startAnimating];
    
    [NSThread detachNewThreadSelector:@selector(checkStatus) toTarget:self withObject:nil];
}

- (IBAction)btnFresh:(id)sender {
    [self startCheckStatus];
}
- (void)checkStatus{
    NSLog(@"UI:checkNework request sent to core.");
    NSNumber *isLogin,*isZjuWlan;
    
    NSInteger location =[[zjuWlanLogin new] judgeLocaton];
    if (location == UNZJUWLAN) {
        isLogin = [NSNumber numberWithBool:0];
        isZjuWlan = [NSNumber numberWithBool:0];
    }
    else {
        isZjuWlan = [NSNumber numberWithBool:1];
        if ([[zjuWlanLogin new] isLogin]) {
            isLogin = [NSNumber numberWithBool:1];
        }
        else{
            isLogin = [NSNumber numberWithBool:0];
        }
    }
    NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:isLogin,@"isLogin",isZjuWlan,@"isZjuWlan", nil];
    NSLog(@"UI:got result from core.");
        
    [self performSelectorOnMainThread:@selector(freshStatus:) withObject:msg waitUntilDone:NO];
}
- (void)freshStatus:(NSDictionary *)msg{
    [aFreshing stopAnimating];
    aFreshing.alpha = 0.0f;
    
    
    if([(NSNumber *)[msg objectForKey:@"isLogin"] boolValue]){
        lblStatus.text = TEXT_LOGIN;
        //btnLogOut.enabled = YES;
        return;
    }
    if([(NSNumber *)[msg objectForKey:@"isZjuWlan"] boolValue]){
        //able to login
        lblStatus.text = TEXT_UNLOGIN;
        //btnLogIn.enabled = YES;
    }
    else{        
        lblStatus.text = TEXT_UNZJUWLAN;
    }
    
}
- (void)logIn{
    __block DemoHintView* hintLoggingView ;
    //[activityIndicatorView startAnimating];
    __block DemoHintView* hintView;
    hintLoggingView = [DemoHintView  infoHintView];
    // Overwrites the pages titles
    hintLoggingView.title = @"求是潮－提示";
    hintLoggingView.hintID = kHintID_Home;
    [hintLoggingView addPageWithTitle:@"ZJUWLAN" text:@"请稍候..."];
    [hintLoggingView showInView:self.view orientation:kHintViewOrientationBottom];
    
    [NSThread sleepForTimeInterval:0.1f];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:txtUserName.text,@"zjuUserName",
                              txtPassWord.text,@"zjuPassWord",  nil];
    //UIAlertView *alert;
    
    NSLog(@"UI:login request sent to core. ");
       
    NSInteger result =[[zjuWlanLogin new] logIn:userInfo];
    NSLog(@"UI:got result from core.");
    [hintLoggingView dismiss];
    
    
    
    switch (result) {
            case SUCCESS:
            hintView = [DemoHintView  infoHintView];            
            // Overwrites the pages titles
            hintView.title = @"求是潮－提示";
            hintView.hintID = kHintID_Home;
            [hintView addPageWithtitle:@"ZJUWLAN" text:@"登录成功!" buttonText:@"好的嘛" buttonAction:^{
                [DemoHintView enableHints:NO];
                [hintView dismiss];
            }];
            break;
        case LACK_USERNAME_OR_PASSWORD:
            hintView = [DemoHintView  infoHintView];
            // Overwrites the pages titles
            hintView.title = @"求是潮－提示";
            hintView.hintID = kHintID_Home;
            [hintView addPageWithtitle:@"ZJUWLAN" text:@"请输入用户名，密码。" buttonText:@"好的嘛" buttonAction:^{
                [DemoHintView enableHints:NO];
                [hintView dismiss];
            }];
            break;
        case NETWORK_ERROR:
            hintView = [DemoHintView  infoHintView];
            // Overwrites the pages titles
            hintView.title = @"求是潮－提示";
            hintView.hintID = kHintID_Home;
            [hintView addPageWithtitle:@"ZJUWLAN" text:@"抱歉，网络错误。请重试..." buttonText:@"好的嘛" buttonAction:^{
                [DemoHintView enableHints:NO];
                [hintView dismiss];
            }];
            break;
    }
    //[activityIndicatorView stopAnimating];
    [hintView showInView:self.view orientation:kHintViewOrientationTop];
    //[alert show];
    [self startCheckStatus];
}
- (IBAction)btnLogIn:(id)sender {
    [txtPassWord resignFirstResponder];
    [txtUserName resignFirstResponder];
    NSLog(@"UI:btnLogIn pressed");
    __block DemoHintView* hintLoggingView ;
    //[activityIndicatorView startAnimating];
    __block DemoHintView* hintView;
    hintLoggingView = [DemoHintView  infoHintView];
    // Overwrites the pages titles
    hintLoggingView.title = @"求是潮－提示";
    hintLoggingView.hintID = kHintID_Home;
    [hintLoggingView addPageWithTitle:@"ZJUWLAN" text:@"请稍候..."];
    [hintLoggingView showInView:self.view orientation:kHintViewOrientationBottom];
    
    if (txtUserName.text == @"" || txtPassWord.text == @"") {
        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"请输入用户名，密码。" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        [hintLoggingView dismiss];
        return;
    }
    if ([lblStatus.text isEqualToString:TEXT_UNZJUWLAN]){
        [self startCheckStatus];        
        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"抱歉，您没有连接到ZJUWLAN。请到 设置－无线局域网 里连接。" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        [hintView showInView:self.view orientation:kHintViewOrientationTop];
        [hintLoggingView dismiss];
        return;
    }
    if ([lblStatus.text isEqualToString:TEXT_LOGIN]) {
        [self startCheckStatus];
        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"您已登陆。" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        [hintView showInView:self.view orientation:kHintViewOrientationTop];
        [hintLoggingView dismiss];
        return;
    }
    [hintLoggingView dismiss];
    [self logIn];
    
}

- (IBAction)btnLogOut:(id)sender {
    NSLog(@"UI:btnLogOut pressed.");
    [activityIndicatorView startAnimating];
    __block DemoHintView* hintLoggingView ;
    //[activityIndicatorView startAnimating];
    __block DemoHintView* hintView;
    hintLoggingView = [DemoHintView  infoHintView];
    // Overwrites the pages titles
    hintLoggingView.title = @"求是潮－提示";
    hintLoggingView.hintID = kHintID_Home;
    [hintLoggingView addPageWithTitle:@"ZJUWLAN" text:@"请稍候..."];
    [hintLoggingView showInView:self.view orientation:kHintViewOrientationBottom];
    if ([lblStatus.text isEqualToString:TEXT_UNZJUWLAN]) {
        [self startCheckStatus];
        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"抱歉，您没有连接到ZJUWLAN。请到 设置－无线局域网 里连接。" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        [hintView showInView:self.view orientation:kHintViewOrientationTop];
        [activityIndicatorView stopAnimating];
        [hintLoggingView dismiss];
        return;
        //[hintView showInView:self.view orientation:kHintViewOrientationTop];
    }
    else if ([lblStatus.text isEqualToString:TEXT_UNLOGIN]){
        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"抱歉，您还没有登录。" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        [hintView showInView:self.view orientation:kHintViewOrientationTop];
        [activityIndicatorView stopAnimating];
        [hintLoggingView dismiss];
        return;
        //[hintView showInView:self.view orientation:kHintViewOrientationTop];
    }
    else{

        [[zjuWlanLogin new] logOut];
    
        [hintLoggingView dismiss];
        [activityIndicatorView stopAnimating];

        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"注销成功！" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        
        [self startCheckStatus];
        [hintView showInView:self.view orientation:kHintViewOrientationTop];
        return;
    }
}


- (IBAction)touchBackground:(id)sender {
    [txtPassWord resignFirstResponder];
    [txtUserName resignFirstResponder];
}

- (IBAction)finishInputId:(id)sender {
    [txtPassWord becomeFirstResponder];
}

- (IBAction)finishInputPassWord:(id)sender {
    [txtPassWord resignFirstResponder];
    [self logIn];
}
@end
