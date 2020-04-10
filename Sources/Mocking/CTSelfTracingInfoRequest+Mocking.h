#import <ContactTracking/CTSelfTracingInfoRequest.h>

@interface CTSelfTracingInfoRequest ()

@property (readwrite) NSTimeInterval selfTracingRequestDelay;
@property (nullable, strong) CTSelfTracingInfo *selfTracingInfoMock;
@property (nullable, strong) NSError *completionHandlerErrorMock;

@end
