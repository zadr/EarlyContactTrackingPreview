#import "CTExposureDetectionSession.h"
#import "CTExposureDetectionSession+Mocking.h"


@interface CTExposureDetectionSession ()

@property BOOL didAuthorize;
@property BOOL didInvalidate;

@property (nullable, copy) dispatch_block_t activationBlock;
@property (nullable, copy) dispatch_block_t addPositiveDiagnosisKeysBlock;
@property (nullable, copy) dispatch_block_t finishedPositiveDiagnosisKeysBlock;
@property (nullable, copy) dispatch_block_t getContactInfoBlock;

@end


@implementation CTExposureDetectionSession

@synthesize maxKeyCount = _maxKeyCount;

- (NSInteger) maxKeyCount {
	NSAssert(self.didAuthorize, @"Cannot add keys until auth completes");

	return _maxKeyCount;
}

- (void) activateWithCompletion:(CTErrorHandler) inCompletion {
	NSAssert(self.didInvalidate == NO, @"Cannot re-activate an invalidated session");

	dispatch_queue_t queue = (self.dispatchQueue ?: dispatch_get_main_queue());

	self.activationBlock = dispatch_block_create(0, ^{
		if (inCompletion != nil) {
			self.didAuthorize = self.activateCompletionHandlerErrorMock == nil;

			inCompletion(self.activateCompletionHandlerErrorMock);
		}
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.activationRequestDelay * NSEC_PER_SEC)), queue, self.activationBlock);
}

- (void) invalidate {
	if (self.activationBlock) {
		if (dispatch_block_testcancel(self.activationBlock) == 0) {
			dispatch_cancel(self.activationBlock);
		}
		self.activationBlock = nil;
	}

	if (self.addPositiveDiagnosisKeysBlock) {
		if (dispatch_block_testcancel(self.addPositiveDiagnosisKeysBlock) == 0) {
			dispatch_cancel(self.addPositiveDiagnosisKeysBlock);
		}
		self.addPositiveDiagnosisKeysBlock = nil;
	}

	if (self.finishedPositiveDiagnosisKeysBlock) {
		if (dispatch_block_testcancel(self.finishedPositiveDiagnosisKeysBlock) == 0) {
			dispatch_cancel(self.finishedPositiveDiagnosisKeysBlock);
		}
		self.finishedPositiveDiagnosisKeysBlock = nil;
	}

	if (self.getContactInfoBlock) {
		if (dispatch_block_testcancel(self.getContactInfoBlock) == 0) {
			dispatch_cancel(self.getContactInfoBlock);
		}
		self.getContactInfoBlock = nil;
	}

	self.didInvalidate = YES;
	self.didAuthorize = NO;
}

- (void) addPositiveDiagnosisKeys:(NSArray <CTDailyTracingKey *> *) inKeys completion:(CTErrorHandler) inCompletion {
	NSAssert(self.didInvalidate == NO, @"Cannot add positive diagnosis keys on an invalidated session");
	NSAssert(self.didAuthorize == YES, @"Cannot add positive diagnosis keys until auth completes");

	dispatch_queue_t queue = (self.dispatchQueue ?: dispatch_get_main_queue());

	self.addPositiveDiagnosisKeysBlock = dispatch_block_create(0, ^{
		if (inCompletion != nil) {
			inCompletion(self.addPositiveDiagnosisKeysCompletionHandlerErrorMock);
		}
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.addPositiveDiagnosisRequestDelay * NSEC_PER_SEC)), queue, self.addPositiveDiagnosisKeysBlock);
}

- (void) finishedPositiveDiagnosisKeysWithCompletion:(CTExposureDetectionFinishHandler) inFinishHandler {
	NSAssert(self.didInvalidate == NO, @"Cannot request finished positive diagnosis on an invalidated session");
	NSAssert(self.didAuthorize == YES, @"Cannot request finished positive diagnosis until auth completes");

	dispatch_queue_t queue = (self.dispatchQueue ?: dispatch_get_main_queue());

	self.finishedPositiveDiagnosisKeysBlock = dispatch_block_create(0, ^{
		if (inFinishHandler != nil) {
			inFinishHandler(self.finishedPositiveDiagnosisKeysWithCompletionHandlerSummaryMock, self.finishedPositiveDiagnosisKeysWithCompletionHandlerErrorMock);
		}
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.finishedPositiveDiagnosisRequestDelay * NSEC_PER_SEC)), queue, self.finishedPositiveDiagnosisKeysBlock);
}

- (void) getContactInfoWithHandler:(CTExposureDetectionContactHandler) inHandler {
	NSAssert(self.didInvalidate == NO, @"Cannot get contact info on an invalidated session");
	NSAssert(self.didAuthorize == YES, @"Cannot get contact info until auth completes");

	dispatch_queue_t queue = (self.dispatchQueue ?: dispatch_get_main_queue());

	self.getContactInfoBlock = dispatch_block_create(0, ^{
		if (inHandler != nil) {
			inHandler(self.getContactInfoWithCompletionHandlerContactsMock, self.getContactInfoWithCompletionHandlerErrorMock);
		}
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.getContactInfoDiagnosisRequestDelay * NSEC_PER_SEC)), queue, self.getContactInfoBlock);
}

@end
