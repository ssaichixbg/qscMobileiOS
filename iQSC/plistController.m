//
//  plistController.m
//  iNotice
//
//  Created by zy on 12-11-4.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "plistController.h"

@implementation plistController
//get complete path accroding to file's name
-(NSString *)getPath:(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *pathname = [paths objectAtIndex:0];
	return [pathname stringByAppendingPathComponent:path ];
    
}
//load the plist file accroding to file's name
-(NSMutableDictionary *)loadPlistFile:(NSString *)path{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    path = [self getPath:path];
    if ([fileManager fileExistsAtPath:path]){
        NSMutableDictionary *plist ;
        @try{
            plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            return plist;
        }
        @catch (NSException *ex) {
            return nil;
        }
    }
    return nil;
}

-(BOOL)savePlistFile:(NSDictionary *)plist filename:(NSString *)pathStr{
    @try{
        [plist writeToFile:[self getPath:pathStr] atomically:YES];
        return YES;
    }
    @catch(NSException *ex){
        return NO;
    }
}
@end
