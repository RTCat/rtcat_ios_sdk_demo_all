//
//  Connector.h
//  RTCatSDK
//
//  Created by cong chen on 1/9/17.
//  Copyright © 2017 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ConnectorDelegate <NSObject>


-(void)connectorOpen;

-(void)connectorClosed;

-(void)connectorMessage:(NSString *)message;

-(void)connectorError:(NSError *)error;

@end

@interface Connector : NSObject

@property (nonatomic, weak) id<ConnectorDelegate> delegate;


-(instancetype)initWithUrl:(NSString *)url Protocol:(NSString *)protocol;

-(void)connect;

-(void)sendMessage:(NSString *)message;

-(void)sendDictionary:(NSDictionary *)dic;

-(void)close;

@end
