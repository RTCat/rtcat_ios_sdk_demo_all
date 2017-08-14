//
//  RTCatPublisher.h
//  RTCatSDK
//
//  Created by spacetime on 7/19/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTCatPublisher : NSObject



@end

@protocol RTCatPublisherDelegate <NSObject>

-(void)publisherConnected:(RTCatPublisher*)publisher;
-(void)publisherClosed:(RTCatPublisher*)publisher;
-(void)publisher:(RTCatPublisher*)publisher log:(NSDictionary*)log;
@end



@interface RTCatPublisher()

@property(weak,nonatomic) id<RTCatPublisherDelegate> delegate;

-(void)close;
@end


