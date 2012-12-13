//
//  helpViewController.h
//  iQSC
//
//  Created by zy on 12-11-29.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface helpViewController : UIViewController<UIScrollViewDelegate>{
    
}
- (IBAction)btnBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollVIew;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
