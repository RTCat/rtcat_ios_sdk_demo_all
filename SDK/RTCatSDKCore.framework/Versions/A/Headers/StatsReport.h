//
//  StatsReport.h
//  RTCatSDKCore
//
//  Created by spacetime on 2/16/17.
//  Copyright © 2017 LearningTech. All rights reserved.
//

#ifndef StatsReport_h
#define StatsReport_h

@interface StatsReport : NSObject


/** Time since 1970-01-01T00:00:00Z in milliseconds. */
@property(nonatomic, readonly) CFTimeInterval timestamp;

/** The type of stats held by this object. */
@property(nonatomic, readonly) NSString *type;

/** The identifier for this object. */
@property(nonatomic, readonly) NSString *reportId;

/** A dictionary holding the actual stats. */
@property(nonatomic, readonly) NSDictionary<NSString *, NSString *> *values;

@end


#endif /* StatsReport_h */
