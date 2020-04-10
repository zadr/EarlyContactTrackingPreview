#import <ContactTracking/CTStateGetRequest.h>

@interface CTStateGetRequest ()

@property (readwrite) CTManagerState mockState;

@property (readwrite) NSTimeInterval stateGetRequestDelay;
@property (nullable, strong) NSError *completionHandlerErrorMock;

@end
