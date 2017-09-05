//
//  RTCatSFUSession.h
//  RTCatSDK
//
//  Created by spacetime on 7/19/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCatPublisher.h"
#import "RTCatSubscriber.h"
#import "RTCatLocalStream.h"

@interface RTCatSFUSession : NSObject

@end

@protocol RTCatSFUSessionDelegate <NSObject>
-(void)sessionConnected:(RTCatSFUSession*)session routes:(NSArray<NSString*>*)routes;
-(void)sessionDisconnected:(RTCatSFUSession*)session;
-(void)session:(RTCatSFUSession*)session error:(NSError*)error;
-(void)session:(RTCatSFUSession*)session published:(NSString*)tokenId;
-(void)session:(RTCatSFUSession*)session unPublished:(NSString*)tokenId;

@end


@interface RTCatSFUSession()
-(void)connect;
-(void)disconnect;
-(void)publish:(RTCatPublisher*)publisher callback:(void (^)(NSDictionary*data))callback;
-(void)unpublish:(RTCatPublisher*)subscriber callback:(void (^)(NSDictionary*data))callback;
-(void)subscribe:(RTCatSubscriber*)subscriber callback:(void (^)(NSDictionary*data))callback;
-(void)unsubscribe:(RTCatSubscriber*)subscriber callback:(void (^)(NSDictionary*data))callback;
-(void)addDelegate:(id<RTCatSFUSessionDelegate>)delegate;
-(RTCatPublisher*)createPublisher:(RTCatLocalStream*)stream;
-(RTCatSubscriber*)createSubscriber:(NSString*)tokenId;

@end
