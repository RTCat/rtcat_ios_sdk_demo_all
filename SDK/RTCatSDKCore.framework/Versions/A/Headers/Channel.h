//
//  Channel.h
//  RTCatSDK
//
//  Created by cong chen on 1/9/17.
//  Copyright © 2017 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
@end

@protocol ChannelDelegate <NSObject>

-(void)channelOpen:(Channel *)channel;
-(void)channelClosed:(Channel *)channel;
-(void)channel:(Channel *)channel Data:(NSData *)data;
-(void)channel:(Channel *)channel Error:(NSError *)error;

@end

@interface Channel()

@property (nonatomic,strong) NSString *label;

-(void)sendMessage:(NSString *)message;

-(void)sendDictionary:(NSDictionary *)dic;

-(void)sendData:(NSData *)data Binary:(BOOL)binary;

@property (nonatomic, weak) id<ChannelDelegate> delegate;

@end
