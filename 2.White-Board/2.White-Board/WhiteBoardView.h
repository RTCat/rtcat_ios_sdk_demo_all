//
//  WhiteBoardView.h
//  demo2
//
//  Created by spacetime on 10/26/16.
//  Copyright © 2016 spacetime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WhiteBoardDelegate <NSObject>

- (void) messageHandler:(NSString*)type X:(float)x Y:(float)y;

@end

@interface WhiteBoardView : UIView


@property(nonatomic,weak) id <WhiteBoardDelegate> delegate;

- (void) drawOtherHandle:(NSString*)type X:(float)x Y:(float)y ;
- (void) addDelegate :(id<WhiteBoardDelegate> )delegate;

@end


