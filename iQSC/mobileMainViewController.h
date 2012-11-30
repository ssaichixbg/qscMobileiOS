//
//  mobileMainViewController.h
//  iNotice
//
//  Created by zy on 12-11-7.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "qscApiController.h"
//#import "ZipArchive.h"
#define INDEX @"http://m.myqsc.com/dev"
@interface mobileMainViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView  *myWebView;
    UIActivityIndicatorView *activityIndicatorView;
    UIAlertView *myAlert;
}
@property (nonatomic, strong) UIWebView *myWebView;

- (void)loadWebPage:(NSString *)urlString;
- (void)loadWebPageWithFile:(NSString *) pathString;

@end