//
//  TestPlayer.m
//  RTCatSDK
//
//  Created by spacetime on 8/4/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

#import "TestPlayer.h"

@interface TestPlayer(PlayerDelegate)<RTCatVideoPlayerDelegate>@end


@interface TestPlayer(){
    UIView* _view;
    ModeType _mode;
    NSMutableDictionary<NSString*,RTCatVideoPlayer*> *_players;
    NSUInteger _count;
    NSMutableArray* _containers;
    NSMutableArray* _poses;
}
@end


@implementation TestPlayer

-(instancetype)initWithMainView:(UIView*)view playMode:(ModeType)mode count:(NSUInteger)count{
    if(self = [super init]){
        _view = view;
        _mode = mode;
        _count = count;
        _players = [NSMutableDictionary dictionary];
        _poses = [NSMutableArray arrayWithCapacity:count];
        _containers = [NSMutableArray array];
        
        int rowCount = (int)sqrt(_count);
        int width = view.bounds.size.width/rowCount;
        int height = view.bounds.size.height/rowCount;
        
        for (int i = 0; i < count; i++) {
            CGRect rect = CGRectMake(
                                     (i%rowCount)*width,
                                     (i/rowCount)*height,
                                     width,
                                     height);
            
            UIView *container = [[UIView alloc] initWithFrame:rect];
            [_poses addObject:@0];
            [_containers addObject:container];
            [container clipsToBounds];
            [_view addSubview:container];
        }
        
    }
    
    return self;
}

-(void)playStream:(RTCatAbstractStream*)stream token:(NSString*)token{
    UIView *container;
    
    for (UIView* con in _containers) {
        if ([con subviews].count == 0){
            container = con;
            break;
        }
    }
    
    RTCatVideoPlayer *player = [[RTCatVideoPlayer alloc] initWithFrame:CGRectZero Type:RTCAT_REMOTE_VIDEO_PLAYER];
    
    player.delegate = self;
    
    NSLog(@"set player delegate");
    
    [container addSubview:player.view];
    
    [stream playWithPlayer:player];
    
    [_players setObject:player forKey:token];
}

-(void)removeStream:(NSString*)token{
    RTCatVideoPlayer* player = [_players objectForKey:token];
    [_players removeObjectForKey:token];
    [player.view removeFromSuperview];
}


-(void)clear{
    for(NSString *key in _players){
        [_players[key].view removeFromSuperview];
    }
    [_players removeAllObjects];
}

@end


@implementation TestPlayer(PlayerDelegate)

-(void)didChangeVideoSize:(RTCatVideoPlayer *)videoPlayer Size:(CGSize)size{
    NSLog(@"didChangeVideoSize height:%f*width:%f",size.height,size.width);
    UIView *container = videoPlayer.view.superview;
    CGRect bounds =  container.bounds;
    
    float A_W = bounds.size.width;
    float A_H = bounds.size.height;
    
    float B_W = size.width;
    float B_H = size.height;
    
    float W,H;
    
    if((A_W/A_H < B_W/B_H) != (_mode == MODE_FULL)){ //定宽
        W = A_W;
        H = W * B_H/B_W;
    }else{ //定高
        H = A_H;
        W = H * B_W/B_H;
    }
    
    bounds.size.width = W;
    bounds.size.height = H;
    
    videoPlayer.view.frame = bounds;
    videoPlayer.view.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    
    NSLog(@"change bounds to :%f,%f",bounds.size.width,bounds.size.height);
    [_view setNeedsLayout];
}

@end
