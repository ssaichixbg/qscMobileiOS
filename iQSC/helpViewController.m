//
//  helpViewController.m
//  iQSC
//
//  Created by zy on 12-11-29.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "helpViewController.h"
#define PAGE_NUMBER 3
@interface helpViewController ()

@end

@implementation helpViewController
@synthesize scrollVIew,pageControl;
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
	// Do any additional setup after loading the view.
    scrollVIew.pagingEnabled = YES;
    scrollVIew.showsHorizontalScrollIndicator = NO;
    scrollVIew.showsVerticalScrollIndicator = YES;
    [scrollVIew setContentSize:CGSizeMake(320 * PAGE_NUMBER,480)];
    scrollVIew.delegate = self;
    pageControl.numberOfPages = PAGE_NUMBER;
    pageControl.userInteractionEnabled = NO;
    
    for (int i = 0; i < PAGE_NUMBER; i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + 320*i, 0, self.view.frame.size.width, 480)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"help_%d.png",i+1]];
        [self.scrollVIew addSubview:imageView];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollVIew.contentOffset.x) / scrollVIew.frame.size.width;
    pageControl.currentPage = index;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollVIew:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}
- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
