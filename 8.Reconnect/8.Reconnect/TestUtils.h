//
//  TestUtils.h
//  RTCatSDK
//
//  Created by spacetime on 8/4/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTCatSDK/RTCat.h>

@interface TestUtils : NSObject


+(void)getToken:(void (^)(NSString*))callback;

@end
