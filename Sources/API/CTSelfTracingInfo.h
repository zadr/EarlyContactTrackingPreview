#import <Foundation/Foundation.h>


@class CTDailyTracingKey;


NS_ASSUME_NONNULL_BEGIN

/// Contains the Daily Tracing Keys.
@interface CTSelfTracingInfo : NSObject

/// Daily tracing keys available at the time of the request.
@property (readonly, copy) NSArray <CTDailyTracingKey *> * dailyTracingKeys;

@end

NS_ASSUME_NONNULL_END
