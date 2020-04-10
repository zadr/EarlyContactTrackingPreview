#import <ContactTracking/CTStateSetRequest.h>

@interface CTStateSetRequest ()

@property (readwrite) NSTimeInterval stateSetRequestDelay;
@property (nullable, strong) NSError *completionHandlerErrorMock;

@end
