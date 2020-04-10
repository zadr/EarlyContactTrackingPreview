#import "CTSelfTracingInfoRequest.h"
#import "CTSelfTracingInfoRequest+Mocking.h"

@interface CTSelfTracingInfoRequest ()

@property (nullable, copy) dispatch_block_t infoBlock;
@property BOOL didInvalidate;

@end


@implementation CTSelfTracingInfoRequest

- (void) perform {
	NSAssert(self.infoBlock == nil, @"Cannot re-use a CTSelfTracingInfoRequest");
	NSAssert(self.didInvalidate == NO, @"Cannot re-use a CTSelfTracingInfoRequest");

	dispatch_queue_t queue = (self.dispatchQueue ?: dispatch_get_main_queue());

	self.infoBlock = dispatch_block_create(0, ^{
		CTSelfTracingInfoGetCompletion completionHandler = self.completionHandler;

		if (completionHandler != nil && !self.didInvalidate) {
			completionHandler(self.selfTracingInfoMock, self.completionHandlerErrorMock);
		}

		self.completionHandler = nil;
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.selfTracingRequestDelay * NSEC_PER_SEC)), queue, self.infoBlock);
}

- (void) invalidate {
	if (self.infoBlock == nil || self.didInvalidate) {
		return;
	}

	if (self.infoBlock) {
		if (dispatch_block_testcancel(self.infoBlock) == 0) {
			dispatch_cancel(self.infoBlock);
		}
		self.infoBlock = nil;
	}

	self.completionHandler = nil;
}

@end
