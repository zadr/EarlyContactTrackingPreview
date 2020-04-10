#import <ContactTracking/CTExposureDetectionSession.h>
#import <ContactTracking/CTDefines.h>

@interface CTExposureDetectionSession ()

@property (readwrite) NSInteger maxKeyCount;

@property (readwrite) NSTimeInterval activationRequestDelay;
@property (nullable, strong) NSError *activateCompletionHandlerErrorMock;

@property (readwrite) NSTimeInterval addPositiveDiagnosisRequestDelay;
@property (nullable, strong) NSError *addPositiveDiagnosisKeysCompletionHandlerErrorMock;

@property (readwrite) NSTimeInterval finishedPositiveDiagnosisRequestDelay;
@property (nullable, strong) CTExposureDetectionSummary *finishedPositiveDiagnosisKeysWithCompletionHandlerSummaryMock;
@property (nullable, strong) NSError *finishedPositiveDiagnosisKeysWithCompletionHandlerErrorMock;

@property (readwrite) NSTimeInterval getContactInfoDiagnosisRequestDelay;
@property (nullable, strong) NSArray <CTContactInfo *> *getContactInfoWithCompletionHandlerContactsMock;
@property (nullable, strong) NSError *getContactInfoWithCompletionHandlerErrorMock;

@end
