//
//  news.h
//  iNotice
//
//  Created by zy on 12-10-29.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface news : NSObject{
    NSNumber *id,
        *like,
        *fans;
    NSString *title,
            *context,
            *start_time,
            *end_time,
            *category,
            *location,
            *tag,
    *organizer;
}
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *context;
@property (nonatomic,retain)NSString *start_time;
@property (nonatomic,retain)NSString *end_time;
@property (nonatomic,retain)NSString *category;
@property (nonatomic,retain)NSString *location;
@property (nonatomic,retain)NSString *tag;
@property (nonatomic,retain)NSString *organizer;
@property (nonatomic,retain)NSNumber *id;
@property (nonatomic,retain)NSNumber *like;
@property (nonatomic,retain)NSNumber *fans;
 
@end
