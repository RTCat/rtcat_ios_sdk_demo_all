//
//  Session.h
//  8.Reconnect
//
//  Created by spacetime on 8/15/17.
//  Copyright © 2017 shishimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTCatSDK/RTCat.h>

@interface Session : NSObject @end

@protocol SessionDelegate <NSObject>

-(void)success;
-(void)failed;

@end

@interface Session()

@property(weak,nonatomic)id<SessionDelegate> delegate;

-(instancetype)initWithStream:(RTCatLocalStream*)stream mainView:(UIView*)view;
-(void)start;
-(void)destory;

@end
