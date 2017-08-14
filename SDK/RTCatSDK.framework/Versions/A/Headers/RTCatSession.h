//
//  Session.h
//  RTCatSDK
//
//  Created by cong chen on 9/6/16.
//  Copyright © 2016 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCatLocalStream.h"
#import "RTCatSender.h"
#import "RTCatReceiver.h"

/**
 *  Session 连接类型
 */
typedef NS_ENUM(int, RTCatSessionType) {
    /**
     *  p2p 连接
     */
    P2P = 0,
    /**
     *  relay 连接
     */
    Relay
};

/**
 *  Session 状态
 */
typedef NS_ENUM(NSInteger, RTCatSessionState) {
    /**
     *  正在连接
     */
    RTCAT_SESSION_CONNECTING   = 0,
    /**
     *  连接成功
     */
    RTCAT_SESSION_OPEN,
    /**
     *  正在关闭
     */
    RTCAT_SESSION_CLOSING,
    /**
     *  已关闭
     */
    RTCAT_SESSION_CLOSED,
};

@interface RTCatSession : NSObject

@end
/**
 *  Session delegate
 */
@protocol RTCatSessionDelegate <NSObject>
@optional
/**
 *  有 token 进入 Session
 *
 *  @param session session对象本身
 *  @param token tokenId
 */
-(void)session:(RTCatSession*)session in:(NSString *)token;

/**
 *  有 token 退出 Session
 *
 *  @param session session对象本身
 *  @param token tokenId
 */
-(void)session:(RTCatSession*)session out:(NSString *)token;

/**
 *  session 连接成功
 *
 *  @param session session对象本身
 *  @param tokens 当前所有已连入的 Session
 */
-(void)session:(RTCatSession*)session connected:(NSArray *)tokens;


/**
 *  Session 关闭
 *  @param session session对象本身
 */
-(void)sessionClose:(RTCatSession*)session;

/**
 *  Session 连接出错
 *
 *  @param session session对象本身
 *  @param error 错误信息
 */
-(void)session:(RTCatSession*)session error:(NSError *)error;

/**
 *  Session 连接 接收器
 *
 *  @param session session对象本身
 *  @param receiver 接收器
 */
-(void)session:(RTCatSession*)session remote:(RTCatReceiver *)receiver;

/**
 *  Session 连入 发送器
 *
 *  @param session session对象本身
 *  @param sender 发送器
 */
-(void)session:(RTCatSession*)session local:(RTCatSender *)sender;

/**
 *  Session 收到消息
 *
 *  @param session session对象本身
 *  @param message 消息
 *  @param token 发送消息的 tokenId
 */
-(void)session:(RTCatSession*)session message:(NSString *)message from:(NSString *)token;

@end

/**
 *  会话
 */
@interface RTCatSession()

/**
 *  连入 Session
 */
-(void)connect;

/**
 *  断开 Session
 */
-(void)disconnect;

/**
 *  广播 Stream , data 并建立连接
 *
 *  @param stream 本地流
 *  @param data   是否建立数据通道
 *  @param attr   通道属性
 */
-(void)sendStream:(RTCatLocalStream *)stream data:(BOOL)data attr:(NSDictionary *)attr;

/**
 *  发送 Stream , data 并建立连接
 *
 *  @param stream  本地流
 *  @param tokenId 接受者的 tokenId
 *  @param data    是否建立数据通道
 *  @param attr    通道属性
 */
-(void)sendStream:(RTCatLocalStream *)stream to:(NSString *)tokenId data:(BOOL)data attr:(NSDictionary *)attr;

/**
 *  设置 delegate
 *
 *  @param delegate delegate
 */
-(void)addDelegate:(id<RTCatSessionDelegate>)delegate;

/**
 *  发送消息
 *
 *  @param message 消息内容
 *  @param tokenId 接受者的 tokenId
 */
-(void)sendMessage:(NSString *)message to:(NSString *)tokenId;

/**
 *  广播消息
 *
 *  @param message 消息内容
 */
-(void)broadcastMessage:(NSString *)message;

@end
