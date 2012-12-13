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
#define TEXT_FRESHING @""
#define TEXT_LOGIN @"好的嘛。。您已经登录到ZJUWLAN。"
#define TEXT_UNZJUWLAN @"好的嘛。。您还没有连接到ZJUWLAN，请到 设置－无线局域网(或Wi-Fi) 中连接到ZJUWLAN。如自动弹出ZJUWLAN登录界面，请关闭 自动登录"
#define TEXT_UNLOGIN @"好的嘛。。您已经连接到ZJUWLAN，请输入学号密码后，点击一键登录。"
#define TEXT_INFO_UNCORRECT @"好的嘛。。请重新输入用户名／密码。"

@interface zjuWlanLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassWord;

@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;
@property (weak, nonatomic) IBOutlet UIButton *btnLogOut;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aFreshing;

- (void)logIn;
- (void)checkStatus;
- (void)startCheckStatus;
- (IBAction)btnFresh:(id)sender;
- (void)freshStatus:(NSDictionary *)msg;
- (IBAction)btnLogIn:(id)sender;
- (IBAction)btnLogOut:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)finishInputId:(id)sender;
- (IBAction)finishInputPassWord:(id)sender;


@end
