//
//  Session.m
//  8.Reconnect
//
//  Created by spacetime on 8/15/17.
//  Copyright © 2017 shishimao. All rights reserved.
//

#import "Session.h"
#import "TestUtils.h"
#import "TestPlayer.h"

@interface Session(SessionDelegate)<RTCatSessionDelegate>@end
@interface Session(SenderDelegate)<RTCatSenderDelegate>@end
@interface Session(ReceiverDelegate)<RTCatReceiverDelegate> @end

@interface Session(){
    RTCat *_cat;
    RTCatSession *_session;
    TestPlayer *_player;
    RTCatLocalStream *_stream;
}

@end


@implementation Session

-(instancetype)initWithStream:(RTCatLocalStream*)stream mainView:(UIView*)view{
    if(self = [super init]){
        _cat = [RTCat shareInstance];
        _stream = stream;
        _player = [[TestPlayer alloc]initWithMainView:view playMode:MODE_NORMAL count:4];
        
    }
    return self;
}


-(void)start{
    [self getToken];
}

-(void)getToken{
    [TestUtils getToken:^(NSString *token) {
        if(token){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self connect:token];
                [_player playStream:_stream token:token];
            });
        }else{
            [_delegate failed];
        }
    }];
}


-(void)connect:(NSString*)token{
    _session = [_cat createSessionWithToken:token];
    [_session addDelegate:self];
    [_session connect];
}


-(void)disconnect{
    if(_session){
        [_player clear];
        [_session disconnect];
    }
}

-(void)destory{
    [self disconnect];
}


@end




@implementation Session(SessionDelegate)

-(void)session:(RTCatSession *)session in:(NSString *)token{
    NSLog(@"%@ is in",token);
    [_session sendStream:_stream to:token data:true attr:@{
                                                           @"test":@"test"}];
}

-(void)session:(RTCatSession *)session out:(NSString *)token{
    [_player removeStream:token];
    NSLog(@"%@ is out",token);
    
}

-(void)session:(RTCatSession *)session connected:(NSArray *)tokens{
    NSLog(@"connected");
    
    [_session sendStream:_stream data:true attr:@{
                                                  @"test":@"test"} ];
    
    [_delegate success];
}

-(void)session:(RTCatSession *)session error:(NSError *)error{
    NSLog(@"session error -> %@",error);
    [self disconnect];
    [_delegate failed];
}

-(void)session:(RTCatSession *)session local:(RTCatSender *)sender{
    sender.delegate = self;
}

-(void)session:(RTCatSession *)session remote:(RTCatReceiver *)receiver{
    receiver.delegate = self;
    [receiver response];
}

-(void)session:(RTCatSession *)session message:(NSString *)message from:(NSString *)token{
}


-(void)sessionClose:(RTCatSession *)session{
    NSLog(@"session closed");
    [_player clear];
    [_delegate failed];
}



@end


@implementation Session(SenderDelegate)



@end

@implementation Session(ReceiverDelegate)

-(void)receiver:(RTCatReceiver *)receiver stream:(RTCatRemoteStream *)stream{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_player playStream:stream token:receiver.getSenderToken];
    });
}

@end

