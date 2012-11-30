//
//  zjuWlanLoginViewController.h
//  iNotice
//
//  Created by zy on 12-11-20.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zjuWlanLogin.h"
#import "DemoHintView.h"
@interface zjuWlanLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassWord;

@property (weak, nonatomic) IBOutlet UIImageView *imgIsLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgIsZJU;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aIisZJU;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aIisLogin;

- (void)logIn;
- (void)checkStatus;
- (void)startCheckStatus;
- (void)freshStatus:(NSDictionary *)msg;
- (IBAction)btnLogIn:(id)sender;
- (IBAction)btnLogOut:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)finishInputId:(id)sender;
- (IBAction)finishInputPassWord:(id)sender;


@end
