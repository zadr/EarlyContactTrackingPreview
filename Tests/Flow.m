#import <ContactTracking/CTContactInfo+Mocking.h>
#import <ContactTracking/CTDailyTracingKey+Mocking.h>
#import <ContactTracking/CTExposureDetectionSession+Mocking.h>
#import <ContactTracking/CTExposureDetectionSummary+Mocking.h>
#import <ContactTracking/CTSelfTracingInfo+Mocking.h>
#import <ContactTracking/CTSelfTracingInfoRequest+Mocking.h>
#import <ContactTracking/CTStateGetRequest+Mocking.h>
#import <ContactTracking/CTStateSetRequest+Mocking.h>

#import <XCTest/XCTest.h>

@interface Flow : XCTestCase
@end

@implementation Flow

- (void) test_run {
	XCTestExpectation *e = [self expectationWithDescription:@"running the thing"];

	// 1. get current device state
	CTStateGetRequest *getRequest = [[CTStateGetRequest alloc] init];
	getRequest.stateGetRequestDelay = 1.0;
	getRequest.mockState = CTManagerStateOff;

	getRequest.completionHandler = ^(NSError *stateGetRequestError) {
		if (getRequest.state == CTManagerStateOff) {

			// 2. if its off, turn it on
			CTStateSetRequest *setRequest = [[CTStateSetRequest alloc] init];
			setRequest.stateSetRequestDelay = 1.0;
			setRequest.state = CTManagerStateOn;

			setRequest.completionHandler = ^(NSError *stateSetRequestError) {

				// 3. make a session for current app run
				CTExposureDetectionSession *session = [[CTExposureDetectionSession alloc] init];
				session.activationRequestDelay = 1.0;

				// 4. activate it with backend servers
				[session activateWithCompletion:^(NSError *inError) {

					// 5. fetch contact info to figure out proximity + duration of interaction with person
					session.getContactInfoWithCompletionHandlerContactsMock = @[
						[[CTContactInfo alloc] init],
						[[CTContactInfo alloc] init],
						[[CTContactInfo alloc] init]
					];

					// guess: timestamp is relative since 1970 and duration is in seconds
					NSDate *today = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0];
					session.getContactInfoWithCompletionHandlerContactsMock[0].duration = today.timeIntervalSince1970;
					session.getContactInfoWithCompletionHandlerContactsMock[0].duration = 300;

					NSDate *yesterday = [NSDate.date dateByAddingTimeInterval:-86400];
					yesterday = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] dateBySettingHour:0 minute:0 second:0 ofDate:yesterday options:0];
					session.getContactInfoWithCompletionHandlerContactsMock[1].duration = yesterday.timeIntervalSince1970;
					session.getContactInfoWithCompletionHandlerContactsMock[1].duration = 900;

					yesterday = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] dateBySettingHour:0 minute:0 second:0 ofDate:yesterday options:0];
					session.getContactInfoWithCompletionHandlerContactsMock[2].duration = yesterday.timeIntervalSince1970;
					session.getContactInfoWithCompletionHandlerContactsMock[2].duration = 300;

					[session getContactInfoWithHandler:^(NSArray<CTContactInfo *> *inContacts, NSError *inError) {
						// oh no
						// we go and get tested based on results
						// 6. notify backend service of positive status by uploading all of our daily traces

						// set some low key count to force batching
						session.maxKeyCount = 3;

						CTSelfTracingInfoRequest *selfTracingInfoRequest = [[CTSelfTracingInfoRequest alloc] init];
						selfTracingInfoRequest.selfTracingRequestDelay = 1.0;
						selfTracingInfoRequest.selfTracingInfoMock = [[CTSelfTracingInfo alloc] init];
						selfTracingInfoRequest.selfTracingInfoMock.dailyTracingKeys = @[
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init],
							[[CTDailyTracingKey alloc] init]
						];

						// give tracing keys some fake key data as well
						for (CTDailyTracingKey *key in selfTracingInfoRequest.selfTracingInfoMock.dailyTracingKeys) {
							key.keyData = [NSUUID.UUID.UUIDString dataUsingEncoding:NSUTF8StringEncoding];
						}

						selfTracingInfoRequest.completionHandler = ^(CTSelfTracingInfo * _Nullable inInfo, NSError * _Nullable inError) {
							NSMutableArray *batch = NSMutableArray.array;
							for (NSUInteger i = 0; i < inInfo.dailyTracingKeys.count; i++) {
								[batch addObject:inInfo.dailyTracingKeys[i]];

								// hacky chunked uploading of things
								if ((i % session.maxKeyCount) == 0 || i == (inInfo.dailyTracingKeys.count - 1)) {
									dispatch_group_t group = dispatch_group_create();
									dispatch_group_enter(group);
									[session addPositiveDiagnosisKeys:batch.copy completion:^(NSError * _Nullable inError) {
										dispatch_group_leave(group);
									}];
									dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
								}
							}
						};

						// 7. notify the backend service we finished uploading recent contacts
						session.finishedPositiveDiagnosisRequestDelay = 1.0;
						session.finishedPositiveDiagnosisKeysWithCompletionHandlerSummaryMock = [[CTExposureDetectionSummary alloc] init];
						session.finishedPositiveDiagnosisKeysWithCompletionHandlerSummaryMock.matchedKeyCount = 3;

						[session finishedPositiveDiagnosisKeysWithCompletion:^(CTExposureDetectionSummary * _Nullable inSummary, NSError * _Nullable inError) {
							[e fulfill];
						}];
					}];
				}];
			};

			[setRequest perform];
		}
	};

	[getRequest perform];

	[self waitForExpectations:@[ e ] timeout:60.0];
}

@end


