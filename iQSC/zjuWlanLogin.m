//
//  zjuWlanLogin.m
//  iNotice
//
//  Created by zy on 12-11-20.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "zjuWlanLogin.h"
@implementation zjuWlanLogin
-(NSMutableURLRequest *)setRequst:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:TIME_OUT];//time limit
    [request setURL:url];
    [request setValue:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; zh-cn) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5" forHTTPHeaderField:@"Üser-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;

}
-(BOOL)isLogin{
    //check wifi connection
    if([self judgeLocaton] == UNZJUWLAN){
        return NO;
    }
    NSHTTPURLResponse *response;
    NSError *er;
    [NSURLConnection sendSynchronousRequest:[self setRequst:@"http://www.zju.edu.cn"] returningResponse:&response error:&er];
    if([response allHeaderFields]){
        NSInteger length = [[[response allHeaderFields] valueForKey:@"Content-Length"] integerValue];
        if(length > 1000){
            NSLog(@"zjuWlanLogin Class:logged in");
            return YES;
        }
        else{
            NSLog(@"zjuWlanLogin Class:haven't logged in");
            return NO;
        }
    }
    else{
    NSLog(@"zjuWlanLogin Class:haven't logged in.Network Error.");
    return NO;
    }
}
-(NSInteger)judgeLocaton{
    NSHTTPURLResponse *response;
    NSError *er;
    NSInteger length=0;
    //check wifi connection
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != ReachableViaWiFi){
        NSLog(@"zjuWlanLogin Class:out of ZJUWLAN");
        return UNZJUWLAN;
    }
    NSURLConnection *conn;
    conn = [[NSURLConnection alloc] initWithRequest:[self setRequst:WLAN1_1_1_1_TEST] delegate:self];
    //[NSThread sleepForTimeInterval:TIME_OUT];
    done_=NO;
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } while (!done_);
    //[conn cancel];
    if([httpResponse allHeaderFields]){
        length= [[[response allHeaderFields] valueForKey:@"Content-Length"] integerValue];
        NSLog(@"zjuWlanLogin Class:location:1.1.1.1");
        return WLAN1_1_1_1;
    }
    
    [NSURLConnection sendSynchronousRequest:[self setRequst:WLAN50_100_LOGINPAGE] returningResponse:&response error:&er];
    if([response allHeaderFields]){
        //length = [[[response allHeaderFields] valueForKey:@"Content-Length"] integerValue];
        NSLog(@"zjuWlanLogin Class:location:50.100");
        return WLAN50_100;
    }
    NSLog(@"zjuWlanLogin Class:out of ZJUWLAN");
    return UNZJUWLAN;
}
-(NSInteger)logIn:(NSDictionary *)userInfo{
    if([self isLogin]){
        return SUCCESS;
    }
    
    NSString *username = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"zjuUserName"] ];
    NSString *password = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"zjuPassWord"] ];
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        NSLog(@"zjuWlanLogin Class:lack of username or password");
        return LACK_USERNAME_OR_PASSWORD;
    }
    
    userInfo_ = [[NSMutableDictionary alloc] initWithObjectsAndKeys:username,@"zjuUserName",password,@"zjuPassWord", nil];
    [self saveInfo];

    
    //sendLoginInfo
    //prepare http request
    NSMutableURLRequest *urlRequest;
    NSData *postData;
    NSString *postStr;
    NSLog(@"zjuWlanLogin Class:judge location...");
    switch ([self judgeLocaton]) {
        case WLAN1_1_1_1:
            urlRequest = [self setRequst:WLAN1_1_1_1_LOGINPAGE];
            postStr = [NSString stringWithFormat:@"buttonClicked=4&err_flag=0&err_msg=&info_flag=0&info_msg=&redirect_url=&username=%@&password=%@",[userInfo objectForKey:@"zjuUserName"],[userInfo objectForKey:@"zjuPassWord"]];
            NSLog(@"%@",postStr);
            //prepare post data
            postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest setHTTPBody:postData];
            [urlRequest setValue:[NSString stringWithFormat:@"%d",postData.length] forHTTPHeaderField:@"Content-Length"];
            break;
        case WLAN50_100:
            urlRequest = [self setRequst:WLAN50_100_LOGINPAGE];
            postStr = [NSString stringWithFormat:@"n=100&is_pad=1&type=1&username=%@&password=%@&drop=0",[userInfo objectForKey:@"zjuUserName"],[userInfo objectForKey:@"zjuPassWord"]];
            //prepare post data
            postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest setHTTPBody:postData];
            [urlRequest setValue:[NSString stringWithFormat:@"%d",postData.length] forHTTPHeaderField:@"Content-Length"];
            break;
        default:
           
            break;
    }
    done_ = NO;
    //send request
    NSLog(@"zjuWlanLogin Class:start to send logging request");
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    //wait for http requesting done
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:3.5f]];
    [conn cancel];
    if([self isLogin]){
        NSLog(@"zjuWlanLogin Class:login successfully");
        return SUCCESS;
    }
    else{
        NSLog(@"zjuWlanLogin Class:failed to login");
        return NETWORK_ERROR;
    }
}

//connection app delecate
//receive http head
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response{
    httpResponse = (NSHTTPURLResponse *)response;
    return;
}
// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    done_ = YES;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    done_ = YES;
    return;
    //[self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
}
//https
- (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"zjuWlanLogin Class:didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}


-(void)logOut{
    NSMutableURLRequest *urlRequest;
    NSString *postStr;
    NSData *postData;
    NSLog(@"zjuWlanLogin Class:sending logging out request");
    
    //send 1.1.1.1 logout request
    urlRequest = [self setRequst:WLAN1_1_1_1_LOGOUTPAGE];
    postStr = @"userStatus=1&err_flag=0&err_msg=";
    //prepare post data
    postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:postData];
    [urlRequest setValue:[NSString stringWithFormat:@"%d",postData.length] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *conn;
    conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:TIME_OUT]];
    [conn cancel];
    
    //send 50.100 logout request
    urlRequest = [self setRequst:WLAN50_100_LOGOUTPAGE];
    [urlRequest setValue:[NSString stringWithFormat:@"%d",4096] forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    
    NSLog(@"sended");

}
-(void)changeUser{
    
}

-(void)saveInfo{
    NSLog(@"zjuWlanLogin Class:save user info");
    [[plistController new] savePlistFile:userInfo_ filename:ZJU_USER_INFO_FILE];
}
-(NSDictionary *)loadInfo{
    NSMutableDictionary *userInfo = [[plistController new] loadPlistFile:ZJU_USER_INFO_FILE];
    userInfo_=userInfo;
    NSLog(@"zjuWlanLogin Class:load user info");
    return userInfo;
}


@end
