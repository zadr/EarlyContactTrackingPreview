#import "CTStateSetRequest.h"
#import "CTStateSetRequest+Mocking.h"

@interface CTStateSetRequest ()

@property (nullable, copy) dispatch_block_t setBlock;
@property BOOL didInvalidate;

@end


@implementation CTStateSetRequest

- (void) perform {
	NSAssert(self.setBlock == nil, @"Cannot re-use a CTStateSetRequest");
	NSAssert(self.didInvalidate == NO, @"Cannot re-use a CTStateSetRequest");

	dispatch_queue_t queue = (self.dispatchQueue ?: dispatch_get_main_queue());

	self.setBlock = dispatch_block_create(0, ^{
		if (self.completionHandler != nil && !self.didInvalidate) {
			self.completionHandler(self.completionHandlerErrorMock);
		}

		self.completionHandler = nil;
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.stateSetRequestDelay * NSEC_PER_SEC)), queue, self.setBlock);
}

- (void) invalidate {
	if (self.setBlock == nil || self.didInvalidate) {
		return;
	}

	if (self.setBlock) {
		if (dispatch_block_testcancel(self.setBlock) == 0) {
			dispatch_cancel(self.setBlock);
		}
		self.setBlock = nil;
	}

	self.completionHandler = nil;
}

@end
