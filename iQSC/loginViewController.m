//
//  ViewController.m
//  iNotice
//
//  Created by zy on 12-10-27.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController ()

@end

@implementation loginViewController
@synthesize txtPassword,txtUserName;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
    NSString *username, *password, *alertStr;
    username = txtUserName.text;
    password = txtPassword.text;
    if(username!= @"" && password != @"" ){
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  username,@"username",
                                  password,@"password", nil];
        //authenticate user's info
        switch ([[loginController new]logIn:userInfo]) {
            case 1://successful
                [self dismissViewControllerAnimated:YES completion:^{}];
                return;
                break;
            case 10://username/pw incorrect
                alertStr = @"username or password are incorrect.";
                break;
            case 20 ://network error
                alertStr = @"network error.";
                break;
            default:
                break;
                alertStr = @"unexpeted error";
        }
        
    }
    else{
        alertStr = @"please type in your username and password";
    }
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"error"
                          message:alertStr
                          delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)userNameEndEditing:(id)sender {
    [txtPassword becomeFirstResponder];
}

- (IBAction)pwEndEditing:(id)sender {
    [txtPassword resignFirstResponder];
}
//close keyboard
- (IBAction)touchBackground:(id)sender {
    [txtPassword resignFirstResponder];
    [txtUserName resignFirstResponder];
}
- (void)viewDidUnload {
    [self setTxtUserName:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
}
@end
