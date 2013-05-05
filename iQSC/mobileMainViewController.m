//
//  ViewController.m
//  iQSCalpha
//
//  Created by zy on 12-10-20.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "mobileMainViewController.h"
#import "NSData+SSToolkitAdditions.h"

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
    
    [self loadWebPageWithFile:@"index.html"];
    [self performSelectorInBackground:@selector(updateAllWebPagesIfNecessary) withObject:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    //[self.myWebView reload];
}

//webview start loading
- (void)webViewDidStartLoad:(UIWebView *)myWebView{
    [activityIndicatorView startAnimating];
    self.myWebView.alpha = 0.0f;
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
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == kCFURLErrorFileDoesNotExist) {
        [self performSelectorInBackground:@selector(updateAllWebPages) withObject:nil];
    }
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

- (NSString *)pathForWebPage:(NSString *)page
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"htmls"];
    path = [path stringByAppendingPathComponent:page];
    return path;
}

- (void)updateWebPage:(NSString *)page
{
    NSString *url = [NSString stringWithFormat:@"http://m.myqsc.com/html-stable/%@",page];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error;
    NSData *data;
    do {
        data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    } while (error != nil);
    NSString *pagePath = [self pathForWebPage:page];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:[pagePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    [manager createFileAtPath:[self pathForWebPage:page] contents:data attributes:nil];
}

//load file
- (void)loadWebPageWithFile:(NSString *) fileName
{
	NSString *path = [self pathForWebPage:fileName];
    @try {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWebView loadRequest:request];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

- (void)updateAllWebPagesIfNecessary
{
    NSDate *last = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdate"];
    if (last == nil || [[NSDate date]timeIntervalSinceDate:last] > 24 * 3600) {
        [self updateAllWebPages];
    }
}

- (void)updateAllWebPages
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.myqsc.com/html-stable/md5.php"]];
    NSString *md5sString = [[NSString alloc]initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    NSArray *md5sArray = [md5sString componentsSeparatedByString:@"\n"];
    for (NSString *md5 in md5sArray) {
        NSArray *md5Entry = [md5 componentsSeparatedByString:@"  "];
        if (md5Entry.count < 2) {
            continue;
        }
        NSString *page = md5Entry[1];
        NSString *remoteMd5 = md5Entry[0];
        NSString *localMd5 = [[NSData dataWithContentsOfFile:[self pathForWebPage:page]]MD5Sum];
        if (![localMd5 isEqualToString:remoteMd5]) {
            [self updateWebPage:page];
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date]forKey:@"LastUpdate"];
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self loadWebPageWithFile:@"index.html"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
