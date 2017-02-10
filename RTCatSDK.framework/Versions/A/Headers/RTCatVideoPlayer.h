//
//  VideoPlayer.h
//  RTCatSDK
//
//  Created by cong chen on 9/7/16.
//  Copyright © 2016 cong chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *
 */
typedef NS_ENUM(NSUInteger, RTCatVideoPlayerType) {
    /**
     *  本地视频流播放器
     */
    RTCAT_LOCAL_VIDEO_PLAYER,
    /**
     *  远程视频流播放器
     */
    RTCAT_REMOTE_VIDEO_PLAYER
    
};


/**
 * 视频播放器
 */
@interface RTCatVideoPlayer: NSObject
@end

/**
 * RTCatVideoPlayer delegate
 */
@protocol RTCatVideoPlayerDelegate <NSObject>
/**
 *  播放器Size调整
 *
 *  @param videoPlayer 视频播放器
 *  @param size CGSize
 */
- (void)didChangeVideoSize:(RTCatVideoPlayer*)videoPlayer Size:(CGSize)size;

@end

@interface RTCatVideoPlayer()

/**
 *  初始化播放器
 *
 *  @param frame CGRect
 *
 *  @return RTCatVideoPlayer
 */
-(instancetype)initWithFrame:(CGRect)frame;


/**
 *  初始化播放器
 *  @param frame CGRect
 *  @param type  RTCatVideoPlayerType
 *  @return RTCatVideoPlayer
 *
 */
-(instancetype)initWithFrame:(CGRect)frame Type:(RTCatVideoPlayerType)type;


/**
 *  播放器的 video
 */
@property (nonatomic, strong) UIView *view;
/**
 *  播放器的 delegate
 */
@property (nonatomic,weak) id<RTCatVideoPlayerDelegate> delegate;
/**
 *  播放器的 bounds
 */
@property (nonatomic,assign,readonly) CGRect bounds;

/**
 *  播放器的 type
 */
@property (nonatomic,readonly) RTCatVideoPlayerType type;

@end
