//
//  settingViewController.m
//  iNotice
//
//  Created by Zju on 12-11-7.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "settingViewController.h"

@interface settingViewController ()

@end

@implementation settingViewController
@synthesize lblAvlbMem,lblUsedMem;
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
    lblAvlbMem.text=@"";
    //[self freshMemoryStatus];
	// Do any additional setup after loading the view.
    lblAvlbMem.text = [NSString stringWithFormat:@"设备可用内存：加载中。。"];
    lblUsedMem.text = [NSString stringWithFormat:@"当前应用所占内存:加载中。。"];

    
}
- (void)viewDidAppear:(BOOL)animated{
    [NSThread detachNewThreadSelector:@selector(freshMemoryStatus) toTarget:self withObject:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)freshMemoryStatus{
    //do {
        //double i =[self availableMemory];
        lblAvlbMem.text = [NSString stringWithFormat:@"设备可用内存：%.01fM",[self availableMemory]];
        lblUsedMem.text = [NSString stringWithFormat:@"当前应用所占内存:%.01fM",[self usedMemory]];
        [NSThread sleepForTimeInterval:5.0f];

    //} while (1==1);
}

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (IBAction)btnFresh:(id)sender {
    lblAvlbMem.text = [NSString stringWithFormat:@"设备可用内存：%.01fM",[self availableMemory]];
    lblUsedMem.text = [NSString stringWithFormat:@"当前应用所占内存:%.01fM",[self usedMemory]];

}
- (void)viewDidUnload {
    [self setLblUsedMem:nil];
    [self setLblAvlbMem:nil];
    [super viewDidUnload];
}
@end
