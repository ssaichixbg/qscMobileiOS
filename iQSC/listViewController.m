//
//  listViewController.m
//  iNotice
//
//  Created by zy on 12-10-30.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "listViewController.h"

@interface listViewController ()

@end

@implementation listViewController
@synthesize noticeList;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*if(![self fresh]){//cannot get the newest list
        UIAlertView *alert =[[UIAlertView alloc ]initWithTitle:@"error"
                         message:@"failed to fresh,please check your network.."
                        delegate:nil
               cancelButtonTitle:@"ok"
               otherButtonTitles:nil,nil];
        [alert show];
    }*/
    //load alert
    if (myAlert==nil){
        myAlert = [[UIAlertView alloc] initWithTitle:nil
                                             message: @"正在加载数据，请稍候..."
                                            delegate: self
                                   cancelButtonTitle: nil
                                   otherButtonTitles: nil];
    }
    [NSThread detachNewThreadSelector:@selector(fresh) toTarget:self withObject:nil];
    //[self fresh];
    [self getNoticeList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.noticeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    NSDictionary *row = [self.noticeList objectAtIndex:indexPath.row];
    //!!!!!!
    switch ([[row objectForKey:@"category" ] integerValue ]) {
        case 1:
            CellIdentifier = @"cell1";
            break;
        case 2:
            CellIdentifier = @"cell2";
            break;
        default:
            CellIdentifier = @"cell1";
            break;
    }
       
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    //!!!!!!
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:0];
    lblTitle.text=(NSString *)[row objectForKey:@"title"];
    
    UILabel *lblStartTime = (UILabel *)[cell viewWithTag:1];
    lblStartTime.text=(NSString *) [row objectForKey:@"start_time"];
    
    UILabel *lblEndTime = (UILabel *)[cell viewWithTag:2];
    lblEndTime.text=(NSString *) [row objectForKey:@"end_time"];
    
    UILabel *lblTieckets = (UILabel *)[cell viewWithTag:3];
    lblTieckets.text=(NSString *) [row objectForKey:@"tiecket"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)fresh{
    [[noticeDataController new] freshDatebase:self];
}


-(BOOL)getNoticeList{
    if(self.noticeList){
        self.noticeList = nil;
    }
    self.noticeList = [[noticeDataController new] getNoticeList];
    if (!(noticeList==nil)) {
        [self.tableView reloadData];
        return  YES;
    }
    else{
    return NO;
    }
}
- (void)viewDidUnload {
    [self setUINavigatior:nil];
    [super viewDidUnload];
}
//goto detail view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    //send current view
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
    //send selected dictionary
    if ([destination respondsToSelector:@selector(setSelectedActivity:)]) {
        NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
        [destination setValue:[self.noticeList objectAtIndex:indexpath.row] forKey:@"selectedActivity"];
    }
}

- (void)httpConnectStart{
    [myAlert show];
}
- (void)httpConnectEnd{
    [self getNoticeList];
    [myAlert dismissWithClickedButtonIndex:0 animated:YES];
}
@end
