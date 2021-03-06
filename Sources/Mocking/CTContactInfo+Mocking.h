#import <ContactTracking/CTContactInfo.h>

@interface CTContactInfo ()

/// How long the contact was in proximity. Minimum duration is 5 minutes and increments by 5 minutes: 5, 10, 15, etc.
@property (readwrite) NSTimeInterval duration;

/// This property contains the time when the contact occurred. This may have reduced precision, such as within one day of the actual time.
@property (readwrite) CFAbsoluteTime timestamp;

@end
