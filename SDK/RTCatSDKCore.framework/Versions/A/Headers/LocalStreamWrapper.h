//
//  LocalStreamWrapper.h
//  RTCatSDK
//
//  Created by cong chen on 1/6/17.
//  Copyright © 2017 cong chen. All rights reserved.
//

#import <AVFoundation/AVCaptureSession.h>
#import <Foundation/Foundation.h>
#import "StreamWrapper.h"

@interface LocalStreamWrapper : StreamWrapper

@property(nonatomic, readonly) AVCaptureSession *captureSession;

-(void)switchCamera;
-(void)adaptFormatToWidth:(int)width height:(int)height fps:(int)fps;;
-(LocalStreamWrapper *)clone;

@end
