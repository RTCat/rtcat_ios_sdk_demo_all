//
//  Peer.h
//  RTCatSDK
//
//  Created by cong chen on 9/9/16.
//  Copyright © 2016 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Peer 类型
 */
typedef NS_ENUM(NSUInteger, RTCatPeerType) {
    /**
     *  sender
     */
    RTCAT_PEER_TYPE_SENDER   = 0,
    /**
     *  receiver
     */
    RTCAT_PEER_TYPE_RECEIVER,

};


/**
 *  通道状态
 */
typedef NS_ENUM(NSUInteger, RTCatPeerState) {
    /**
     *  连接断开或者未连接
     */
    DISCONNECTED = 0,
    /**
     *  连接中
     */
    CONNECTING,
    /**
     *  连接成功
     */
    CONNECTED
};

/**
 *  实时猫连接通道
 */
@interface RTCatPeer : NSObject

/**
 *  获得通道属性
 *
 *  @return 通道属性
 */
-(NSDictionary *)getAttr;

/**
 *  获得通道编号
 *
 *  @return 通道编号
 */
-(NSString *)getId;


/**
 * 获得通道状态
 * @return 通道状态
 */
-(RTCatPeerState)getState;


/**
 *  关闭通道
 */
-(void)close;
@end