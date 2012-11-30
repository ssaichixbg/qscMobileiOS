//
//  plistController.h
//  iNotice
//
//  Created by zy on 12-11-4.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface plistController : NSObject{
    
}
-(NSMutableDictionary *)loadPlistFile:(NSString *)path;
-(BOOL)savePlistFile:(NSDictionary *)plist filename:(NSString *)pathStr;
-(NSString *)getPath:(NSString *)path;
@end
