//
//  ReconnectViewController.m
//  8.Reconnect
//
//  Created by spacetime on 8/16/17.
//  Copyright © 2017 shishimao. All rights reserved.
//

#import "ReconnectViewController.h"
#import "Session.h"
#import <RTCatSDK/RTCat.h>


@interface ReconnectViewController(SessionDelegate)<SessionDelegate>@end

@interface ReconnectViewController (){
    RTCatLocalStream *_stream;
}



@property(atomic) Session *session;
@property(atomic) BOOL stop;
@property(atomic) BOOL running;
@property(atomic) BOOL trying;


@property(nonatomic) int  times;
@property(nonatomic) int  delay;


@end

@implementation ReconnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RTCat *_cat = [RTCat shareInstance];
    _stream = [_cat createStreamWithVideo:YES audio:YES];
    _running = NO;
    _times = 0;
    _delay = 2;
    _stop = NO;
    
    [self start];
}

-(void)start{
    const NSString *TAG = @"Session-Restart-Loop";
    const int MAXTIMES = 5;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (!_stop) {
            if(!_running){
                if(_times < MAXTIMES){
                    _times ++;
                    NSLog(@"%@:Session stop,try %d/%d time",TAG,_times,MAXTIMES);
                    
                    _trying = true;
                    _session = [[Session alloc] initWithStream:_stream mainView:self.view];
                    _session.delegate = self;
                    [_session start];
                    
                    while (_trying) {
                        [NSThread sleepForTimeInterval:1];
                        NSLog(@"%@:Connecting",TAG);
                    }
                    
                    if(_running){
                        NSLog(@"%@:Connecting succcess",TAG);
                        _delay = 2;
                        _times = 0;
                    }else{
                        [_session destory];
                        _session = nil;
                        NSLog(@"%@:Connecting failed",TAG);
                        NSLog(@"%@:After %d s,retry",TAG,_delay);
                        [NSThread sleepForTimeInterval:_delay];
                        _delay *= 2;
                    }
                
                }else{
                    NSLog(@"%@:Session stop,try %d/%d time",TAG,_times,MAXTIMES);
                    _stop = YES;
                    NSLog(@"%@:Reconnect all failed",TAG);
                }
            }else{
                NSLog(@"%@ checking",TAG);
                [NSThread sleepForTimeInterval:1];
            }
        }
        
        NSLog(@"%@:Stop:%d",TAG,(int)_stop);
        NSLog(@"%@:End",TAG);
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"view did disappear");
    if(_session){
        _stop = YES;
        [_session destory];
        [RTCat release];
    }
}

@end


@implementation ReconnectViewController(SessionDelegate)

-(void)failed{
    _trying = false;
    _running = false;
    NSLog(@"session on faild");
}

-(void)success{
    _trying = false;
    _running = true;
    NSLog(@"session on successed");
}

@end

