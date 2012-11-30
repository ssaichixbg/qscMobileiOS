//
//  ViewController.h
//  iNotice
//
//  Created by zy on 12-10-27.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loginController.h"
@interface loginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
- (IBAction)logIn:(id)sender;
- (IBAction)userNameEndEditing:(id)sender;
- (IBAction)pwEndEditing:(id)sender;
- (IBAction)touchBackground:(id)sender;

@end
