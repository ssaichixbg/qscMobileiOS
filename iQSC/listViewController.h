//
//  listViewController.h
//  iNotice
//
//  Created by zy on 12-10-30.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "noticeDataController.h"

@interface listViewController : UITableViewController{
    UIAlertView *myAlert;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *UINavigatior;
@property(strong,nonatomic)NSMutableArray *noticeList;

-(BOOL)getNoticeList;
-(void)fresh;

- (void)httpConnectStart;
- (void)httpConnectEnd;
@end
