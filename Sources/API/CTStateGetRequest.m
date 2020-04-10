#import "CTStateGetRequest.h"
#import "CTStateGetRequest+Mocking.h"


@interface CTStateGetRequest ()

@property (readwrite) CTManagerState state;
@property (nullable, copy) dispatch_block_t getBlock;
@property BOOL didInvalidate;

@end


@implementation CTStateGetRequest

- (void) perform {
	NSAssert(self.getBlock == nil, @"Cannot re-use a CTStateGetRequest");
	NSAssert(self.didInvalidate == NO, @"Cannot re-use a CTStateGetRequest");

	dispatch_queue_t queue = (self.dispatchQueue ?: dispatch_get_main_queue());

	self.getBlock = dispatch_block_create(0, ^{
		CTErrorHandler completionHandler = self.completionHandler;
		self.state = self.mockState;

		if (completionHandler != nil && !self.didInvalidate) {
			completionHandler(self.completionHandlerErrorMock);
		}

		self.completionHandler = nil;
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.stateGetRequestDelay * NSEC_PER_SEC)), queue, self.getBlock);
}

- (void) invalidate {
	if (self.getBlock == nil || self.didInvalidate) {
		return;
	}

	if (self.getBlock) {
		if (dispatch_block_testcancel(self.getBlock) == 0) {
			dispatch_cancel(self.getBlock);
		}
		self.getBlock = nil;
	}

	self.completionHandler = nil;
}

@end
