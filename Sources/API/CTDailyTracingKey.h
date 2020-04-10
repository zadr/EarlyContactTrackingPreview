#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The Daily Tracing Key object.
@interface CTDailyTracingKey : NSObject

/// This property contains the Daily Tracing Key information.
@property (readonly, copy) NSData *keyData;

@end

NS_ASSUME_NONNULL_END
