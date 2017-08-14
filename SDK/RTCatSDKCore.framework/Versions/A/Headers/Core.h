//
//  Core.h
//  RTCatSDK
//
//  Created by cong chen on 1/6/17.
//  Copyright © 2017 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalStreamWrapper.h"
#import "Peer.h"
#import "WebRTC/RTCConfiguration.h"

@interface Core : NSObject

+ (void)born;

+(LocalStreamWrapper *)createLocalStreamWrapper:(BOOL)hasVideo audio:(BOOL)hasAudio facing:(BOOL)isFront fps:(unsigned int)fps height:(unsigned int)height width:(unsigned int)width ;

+(Peer *)createPeerWithPid:(NSString *)pid IceServers:(NSArray<NSDictionary *> *)iceServers;

+(Peer *)createPeerWithPid:(NSString *)pid PeerConfig:(NSDictionary *)config;

+(void)release;

@end
