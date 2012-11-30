//
//  settingViewController.h
//  iNotice
//
//  Created by Zju on 12-11-7.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

@interface settingViewController : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *lblUsedMem;
@property (weak, nonatomic) IBOutlet UILabel *lblAvlbMem;
- (double)availableMemory;
- (double)usedMemory;
- (IBAction)btnFresh:(id)sender;
- (void)freshMemoryStatus;
@end
