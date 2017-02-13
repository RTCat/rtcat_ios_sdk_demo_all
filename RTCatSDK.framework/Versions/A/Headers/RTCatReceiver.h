//
//  Receiver.h
//  RTCatSDK
//
//  Created by cong chen on 9/8/16.
//  Copyright © 2016 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCatPeer.h"
#import "RTCatRemoteStream.h"

/**
 *  Receiver(接收器)
 */
@interface RTCatReceiver : RTCatPeer
@end

/**
 * Receiver Delegate
 */
@protocol RTCatReceiverDelegate <NSObject>
@optional

/**
 *  接收器收到远程流
 *
 *  @param receiver 接收器本身
 *  @param stream   远程流对象
 */
-(void)receiver:(RTCatReceiver *)receiver stream:(RTCatRemoteStream *)stream;

/**
 *  接收器收到消息
 *
 *  @param receiver 接收器本身
 *  @param message   消息
 */
-(void)receiver:(RTCatReceiver *)receiver message:(NSString *)message;

/**
 *  接收器收到错误
 *
 *  @param receiver 接收器本身
 *  @param error   错误
 */
-(void)receiver:(RTCatReceiver *)receiver error:(NSError *)error;

/**
 *  接收器关闭
 *
 *  @param receiver 接收器本身
 */
-(void)receiverClose:(RTCatReceiver *)receiver;


/**
 *  接收器日志
 *
 *  @param receiver 接收器本身
 *  @param log      接收器日志
 */
-(void)receiver:(RTCatReceiver *)receiver log:(NSDictionary *)log;

/**
 *  接收器接收文件完成
 *  @param receiver 接收器本身
 *  @param filePath 接收的文件路径
 */
-(void)receiver:(RTCatReceiver *)receiver filePath:(NSString *)filePath;

/**
 *
 *  接收器收到传送文件请求
 *  @param receiver 接收器本身
 *  @param fileName 文件名
 *
 */
-(void)receiver:(RTCatReceiver *)receiver fileName:(NSString *)fileName;
@end


@interface RTCatReceiver()
@property (nonatomic, weak) id <RTCatReceiverDelegate> delegate;


/**
 *  获得接收器对应 Sender tokenID
 *
 *  @return tokenId
 */
-(NSString *)getSenderToken;


/**
 *  回复 Sender
 */
-(void)response;


/**
 * 确认接受文件
 */
-(void)responseFile;
@end
