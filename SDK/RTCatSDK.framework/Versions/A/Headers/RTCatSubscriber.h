//
//  RTCatSubscriber.h
//  RTCatSDK
//
//  Created by spacetime on 7/19/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCatRemoteStream.h"



@interface RTCatSubscriber : NSObject

@end

@protocol RTCatSubscriberDelegate <NSObject>

-(void)subscriber:(RTCatSubscriber *)subscriber stream:(RTCatRemoteStream*)stream;
-(void)subscriber:(RTCatSubscriber *)subscriber log:(NSDictionary*)log;
-(void)subscriberConnected:(RTCatSubscriber*)subscriber;
-(void)subscriberClosed:(RTCatSubscriber*)subscriber;

@end

@interface RTCatSubscriber()

@property(weak,nonatomic) id<RTCatSubscriberDelegate> delegate;
@property(readonly) NSString* tokenId;

-(void)close;

@end



