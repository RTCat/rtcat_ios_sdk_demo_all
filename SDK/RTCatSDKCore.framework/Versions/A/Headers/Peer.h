//
//  Peer.h
//  RTCatSDK
//
//  Created by cong chen on 1/9/17.
//  Copyright © 2017 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteStreamWrapper.h"
#import "LocalStreamWrapper.h"
#import "Channel.h"
#import "StatsReport.h"


@interface Peer : NSObject

@end

@protocol PeerDelegate <NSObject>

-(void)peer:(Peer *)peer Error:(NSError *)error;
-(void)peer:(Peer *)peer Stream:(RemoteStreamWrapper *)stream;
-(void)peer:(Peer *)peer Ice:(NSDictionary *)ice;
-(void)peerClosed:(Peer *)peer;
-(void)peerConnected:(Peer *)peer;
-(void)peer:(Peer *)peer OfferChannel:(Channel *)channel;
-(void)peer:(Peer *)peer AnswerChannel:(Channel *)channel;

-(void)peer:(Peer *)peer Offer:(NSDictionary *)sdp;
-(void)peer:(Peer *)peer Answer:(NSDictionary *)sdp;

@end

@interface Peer()

@property (nonatomic, weak) id<PeerDelegate> delegate;
@property (nonatomic, strong) NSString *pid;

-(void)addIce:(NSDictionary *)ice;
-(void)offerWithStream:(LocalStreamWrapper *)stream Data:(NSArray *)data Handle:(SEL)handle Target:(id)aTarget;

-(void)answerWithSDP:(NSDictionary *)sdp Stream:(LocalStreamWrapper *)stream Handle:(SEL)handle Target:(id)aTarget;

-(void)fofferWithSDP:(NSDictionary *)sdp;

-(void)close;

-(void)getStats:(void (^)(NSArray<StatsReport *> *stats))completionHandler;

@end
