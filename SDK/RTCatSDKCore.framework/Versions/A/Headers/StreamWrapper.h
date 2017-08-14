//
//  StreamWrapper.h
//  RTCatSDK
//
//  Created by cong chen on 1/6/17.
//  Copyright © 2017 cong chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamWrapper : NSObject

-(void)setVideoEnabled:(BOOL)enabled;
-(void)setAudioEnabled:(BOOL)enabled;
-(BOOL)isVideoEnabled;
-(BOOL)isAudioEnabled;
-(BOOL)hasVideo;
-(BOOL)hasAudio;

@end
