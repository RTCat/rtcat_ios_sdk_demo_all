//
//  TestUtils.m
//  RTCatSDK
//
//  Created by spacetime on 8/4/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

#import "TestUtils.h"

@implementation TestUtils


+(void)getToken:(void (^)(NSString*))callback{
    
    NSString *sessionId = @"8160a3c5-2a6b-4239-97e8-2d37a6434bdd";
    NSString *apiKey = @"8b8da770-d99c-4617-9f9a-79510505e175";
    NSString *apiSecret = @"262abb49-2ffc-46c6-bdc7-cb27579b21c5";
    NSString *url = [NSString stringWithFormat:@"https://api.realtimecat.com/v0.3/sessions/%@/tokens",sessionId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:apiKey forHTTPHeaderField:@"X-RTCAT-APIKEY"];
    [request setValue:apiSecret forHTTPHeaderField:@"X-RTCAT-SECRET"];
    
    NSString *dataString = [NSString stringWithFormat:@"session_id=%@&type=%@",sessionId,@"pub"];
    NSData *data = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error != nil){
            NSLog(@"get token error %@",error);
            callback(nil);
            return ;
        }
        
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        
        if([object isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *results = object;
            NSString* tokenId = [results objectForKey:@"uuid"];
            NSLog(@"my token is %@",tokenId);
            
            callback(tokenId);
        }else{
            callback(nil);
        }

        
    }];
    
    [task resume];
}


@end
