//
//  Player.h
//  RTCatSDK
//
//  Created by cong chen on 1/6/17.
//  Copyright © 2017 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamWrapper.h"
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, PlayerType) {
    PLAYER_EAGL_VIDEO_VIEW,
    PLAYER_CAMERA_PREVIEW_VIEW
    
};

@protocol PlayerDelegate <NSObject>

-(void)didChangeVideoSize:(CGSize)size;

@end


@interface Player : NSObject

@property(weak,nonatomic) id<PlayerDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;

-(instancetype)initWithFrame:(CGRect)frame Type:(PlayerType)type;

-(void)play:(StreamWrapper *)stream;

-(UIView *)getView;

@end
