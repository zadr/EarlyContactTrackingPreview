#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Contains information about a single contact incident.
@interface CTContactInfo : NSObject

/// How long the contact was in proximity. Minimum duration is 5 minutes and increments by 5 minutes: 5, 10, 15, etc.
@property (readonly) NSTimeInterval duration;

/// This property contains the time when the contact occurred. This may have reduced precision, such as within one day of the actual time.
@property (readonly) CFAbsoluteTime timestamp;

@end

NS_ASSUME_NONNULL_END
