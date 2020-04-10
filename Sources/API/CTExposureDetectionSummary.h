#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Provides a summary on exposures.
@interface CTExposureDetectionSummary : NSObject

/// This property holds the number of keys that matched for an exposure detection.
@property (readonly) NSInteger matchedKeyCount;

@end

NS_ASSUME_NONNULL_END
