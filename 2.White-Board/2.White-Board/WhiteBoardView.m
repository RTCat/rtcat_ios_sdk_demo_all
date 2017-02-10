//
//  WhiteBoardView.m
//  demo2
//
//  Created by spacetime on 10/26/16.
//  Copyright © 2016 spacetime. All rights reserved.
//

#import "WhiteBoardView.h"


@implementation WhiteBoardView{
    NSMutableArray *myPaths;
    UIBezierPath *myCurPath;
    UIColor *myColor;

    NSMutableArray *otherPaths;
    UIBezierPath *otherCurPath;
    UIColor *otherColor;
    

    int pathWidth;
    
    float viewWidth;
    float viewHeight;
    
}


- (void)addDelegate :(id<WhiteBoardDelegate> )delegate{
    _delegate = delegate;
}


- (void)drawRect:(CGRect)rect{
    
    viewHeight = self.bounds.size.height;
    viewWidth = self.bounds.size.width;
    
    for(int i = 0;i < myPaths.count;i++){
        UIBezierPath *bezierPath = [myPaths objectAtIndex:i];
        [myColor setStroke];
        [bezierPath stroke];
    }
    
    
    for(int i = 0;i < otherPaths.count;i++){
        UIBezierPath *bezierPath = [otherPaths objectAtIndex:i];
        [otherColor setStroke];
        [bezierPath stroke];
    }
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        myPaths = [[NSMutableArray alloc] init];
        myColor = [UIColor blueColor];
        otherPaths = [[NSMutableArray alloc] init];
        otherColor = [UIColor greenColor];
        
        pathWidth = 5;
    }
    
    return self;
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];

    CGPoint point = [touch locationInView:self];

    myCurPath = [[UIBezierPath alloc] init];
    [myCurPath setLineWidth:pathWidth];
    
    [myPaths addObject:myCurPath];

    [myCurPath moveToPoint:point];
    
    [_delegate messageHandler:@"start point" X:(point.x/viewWidth) Y:(point.y/viewHeight)];
    [self setNeedsDisplay];
    
}


-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [myCurPath addLineToPoint:point];
    
    [_delegate messageHandler:@"middle point" X:(point.x/viewWidth) Y:(point.y/viewHeight)];
    [self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [_delegate messageHandler:@"end point" X:(point.x/viewWidth) Y:(point.y/viewHeight)];
}

- (void)drawOtherHandle:(NSString *)type X:(float)x Y:(float)y{
    
    
    CGPoint point = CGPointMake(x* viewWidth, y *viewHeight);
    if([type  isEqualToString: @"start point"]){
        otherCurPath = [[UIBezierPath alloc] init];
        [otherCurPath setLineWidth:pathWidth];
        [otherPaths addObject:otherCurPath];
        [otherCurPath moveToPoint:point];
    }else if([type isEqualToString:@"middle point"]){
        [otherCurPath addLineToPoint:point];
    }else if([type isEqualToString:@"end point"]){
        //
    }
    
    //todo 网络问题可能会导致数据包不按顺序到达，需要对这些绘制点进行排序后再绘制。
    
    [self setNeedsDisplay];
    
}



@end

