//
//  ViewController.m
//  iQSCalpha
//
//  Created by zy on 12-10-20.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "mobileMainViewController.h"

@interface mobileMainViewController ()

@end

@implementation mobileMainViewController
@synthesize myWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    myWebView.delegate=self;
    myWebView.scrollView.bounces = NO;
    //load alert
    if (myAlert==nil){
        myAlert = [[UIAlertView alloc] initWithTitle:nil
                                             message: @"正在加载数据，请稍候..."
                                            delegate: self
                                   cancelButtonTitle: nil 
                                   otherButtonTitles: nil];
    }
    
    
    //load activityIndicatorView
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(120.f, 48.0f, 37.0f, 37.0f)];
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;//color
    [self.view addSubview : activityIndicatorView] ;
    myWebView.alpha = 0.0f;
    //[NSThread detachNewThreadSelector:@selector(getData) toTarget:self withObject:nil];
    //load QSC
    //[self loadWebPage:INDEX];
    //[self unarchive];
    [self loadWebPageWithFile:@"index"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    //[self.myWebView reload];
}

//webview start loading
- (void)webViewDidStartLoad:(UIWebView *)myWebView{
    [activityIndicatorView startAnimating];
    self.myWebView.alpha = 0.0f;
    NSLog(@"fdssf");
    //[myAlert show];
}
//webview stop loading
- (void)webViewDidFinishLoad:(UIWebView *)myWebView
{
    [activityIndicatorView stopAnimating];
    [NSThread detachNewThreadSelector:@selector(waitForInterval:) toTarget:self withObject:nil];
    //[myAlert dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)waitForInterval:(NSNumber *)interval{
    sleep(1.0f);
    self.myWebView.alpha = 1.0f;
}
//error during loading
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"求是潮Mobile"
                                                        message:@"好的嘛。。出错了。"//[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK"
                              , nil];
    [alterview show];
}


/*- (void)unarchive{
    ZipArchive *zip = [ZipArchive new];
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"qscMobileHtml5" ofType:@"zip" inDirectory:@""];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
    [zip UnzipOpenFile:zipPath];
    [zip UnzipFileTo:path overWrite:NO];

}*/


//load url
- (void)loadWebPage:(NSString *) urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
    
    
}
//load file
- (void)loadWebPageWithFile:(NSString *) fileName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *path = [paths objectAtIndex:0];
    //path = [path stringByAppendingPathExtension:fileName];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html" inDirectory:@"qscMobileHtml5"];
    @try {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWebView loadRequest:request];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
