//
//  SFUViewController.m
//  RTCatSDKTest
//
//  Created by spacetime on 8/21/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

#import "SFUViewController.h"
#import <RTCatSDK/RTCat.h>
#import "TestUtils.h"
#import "TestPlayer.h"

@interface SFUViewController(SessionDelegate)<RTCatSFUSessionDelegate>@end
@interface SFUViewController(PublisherDelegate)<RTCatPublisherDelegate>@end
@interface SFUViewController(SubscriberDelegate)<RTCatSubscriberDelegate>@end

@interface SFUViewController (){
    RTCatLocalStream *_localStream;
    RTCat *_cat;
    
    TestPlayer *_player;
    
    RTCatSFUSession *_session;
    
    RTCatPublisher *_publisher;
}

@end

@implementation SFUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cat = [RTCat shareInstance];
    [_cat setLogLevel:RTCAT_LOGGING_INFO];
    [_cat setRelay:YES];
    
    _localStream = [_cat createStreamWithVideo:true audio:true facing:RTCAT_CAMERA_BACK fps:20 height:300 width:300];
    _player = [[TestPlayer alloc] initWithMainView:self.view playMode:MODE_NORMAL count:4];
    [self getToken];
}


-(void)getToken{
    [TestUtils getToken:^(NSString *token) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connect:token];
            [_player playStream:_localStream token:token];
        });
    }];
}


-(void)connect:(NSString*)token{
    NSString *serverUrl = @"wss://sfu.realtimecat.com:8899";
    _session = [_cat createSFUSessionWithToken:token url:serverUrl route:nil];
    [_session addDelegate:self];
    [_session connect];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    if(_session){
        [_session disconnect];
        _session = nil;
        _publisher = nil;
    }
}

@end


@implementation SFUViewController(SessionDelegate)

-(void)sessionConnected:(RTCatSFUSession*)session routes:(NSArray *)routes{
    NSLog(@"session connected");
    NSLog(@"routes: %@",routes);
    
    _publisher = [session createPublisher:_localStream];
    _publisher.delegate = self;
//    NSLog(@"create publisher:%@",_publisher);
    [_session publish:_publisher callback:^(NSDictionary *data) {
        NSLog(@"publish callback %@",data);
    }];
    
}
-(void)sessionDisconnected:(RTCatSFUSession*)session{
    NSLog(@"session disconnected");
}
-(void)session:(RTCatSFUSession*)session error:(NSError*)error{
    NSLog(@"session error:%@",error);
}
-(void)session:(RTCatSFUSession*)session published:(NSString*)tokenId{
    NSLog(@"session %@ publishd",tokenId);
    
    RTCatSubscriber *sub = [session createSubscriber:tokenId];
    sub.delegate = self;
    
    [session subscribe:sub callback:^(NSDictionary *data) {
        NSLog(@"subscribe %@ callback %@",tokenId,data);
    }];
}
-(void)session:(RTCatSFUSession*)session unPublished:(NSString*)tokenId{
    NSLog(@"session %@ unpublished",tokenId);
    
    [_player removeStream:tokenId];
}
@end


@implementation SFUViewController(PublisherDelegate)

-(void)publisherConnected:(RTCatPublisher*)publisher{
    NSLog(@"publisher connected");
}
-(void)publisherClosed:(RTCatPublisher*)publisher{
    NSLog(@"publisher closed");
}
-(void)publisher:(RTCatPublisher*)publisher log:(NSDictionary*)log{
    NSLog(@"publisher log:%@",log);
}

@end


@implementation SFUViewController(SubscriberDelegate)

-(void)subscriber:(RTCatSubscriber *)subscriber stream:(RTCatRemoteStream*)stream{
    NSLog(@"subscriber %@ stream",subscriber.tokenId);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_player playStream:stream token:subscriber.tokenId];
    });
}

-(void)subscriber:(RTCatSubscriber *)subscriber log:(NSDictionary*)log{
    NSLog(@"subscriber log:%@",log);
}
-(void)subscriberConnected:(RTCatSubscriber*)subscriber{
    NSLog(@"subscriber connected");
}
-(void)subscriberClosed:(RTCatSubscriber*)subscriber{
    NSLog(@"subscriber closed");
}

@end
