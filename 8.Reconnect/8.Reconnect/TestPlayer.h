//
//  TestPlayer.h
//  RTCatSDK
//
//  Created by spacetime on 8/4/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTCatSDK/RTCat.h>

typedef NS_ENUM(int,ModeType){
    MODE_FULL = 0,
    MODE_NORMAL
};


@interface TestPlayer : NSObject

-(instancetype)initWithMainView:(UIView*)view playMode:(ModeType)mode count:(NSUInteger)count;

-(void)playStream:(RTCatAbstractStream*)stream token:(NSString*)token;

-(void)removeStream:(NSString*)token;

@end
