//
//  Sender.h
//  RTCatSDK
//
//  Created by cong chen on 9/8/16.
//  Copyright © 2016 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCatPeer.h"


/**
 *  Sender 数据通道类型
 */
typedef NS_ENUM(int, RTCatChannelType) {
    /**
     *  message 通道
     */
    RTCAT_MESSAGE_CHANNEL = 0,
    /**
     *  file 通道
     */
    RTCAT_FILE_CHANNEL
};

/**
 *  Sender(发送器)
 */
@interface RTCatSender : RTCatPeer
@end

/**
 *  Sender delegate
 */
@protocol RTCatSenderDelegate <NSObject>
@optional
/**
 *  发送器关闭
 *
 *  @param sender 发送器本身
 */
-(void)senderClose:(RTCatSender *)sender;

/**
 *  发送器出错
 *
 *  @param sender 发送器本身
 *  @param error  发送器错误
 */
-(void)sender:(RTCatSender *)sender error:(NSError *)error;


/**
 *  发送器日志
 *
 *  @param sender 发送器本身
 *  @param log    发送器日志
 */
-(void)sender:(RTCatSender *)sender log:(NSDictionary *)log;


/**
 *  发送器发送文件完成
 *
 *  @param sender 发送器本身
 *  @param fileName  文件名
 */
-(void)sender:(RTCatSender *)sender fileFinished:(NSString *)fileName;


/**
 *
 *  发送器数据通道状态变化
 *  
 *  @param sender 发送器本身
 *  @param type 数据通道类型
 *  @param isOpen 数据通道打开/关闭
 */
-(void)sender:(RTCatSender *)sender channel:(RTCatChannelType)type isOpen:(BOOL)isOpen;
@end


@interface RTCatSender()
@property (nonatomic, weak) id <RTCatSenderDelegate> delegate;



/**
 *  发送消息
 *
 *  @param message 要发送的消息
 */
-(void)sendMessage:(NSString *)message;


/**
 *  获得发送器对应 Receiver tokenID
 *
 *  @return tokenId
 */
-(NSString *)getReceiverToken;

/**
 *  发送文件
 *
 *  @param filePath 要发送的文件URL地址
 */
-(void)sendFile:(NSString*)filePath;


@end
