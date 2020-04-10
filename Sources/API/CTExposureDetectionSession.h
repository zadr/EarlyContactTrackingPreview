#import <Foundation/Foundation.h>
#import <ContactTracking/CTDefines.h>


@class CTContactInfo;
@class CTDailyTracingKey;
@class CTExposureDetectionSummary;


NS_ASSUME_NONNULL_BEGIN

/// The type definition for the completion handler.
typedef void ( ^CTExposureDetectionFinishHandler ) ( CTExposureDetectionSummary * _Nullable inSummary, NSError * _Nullable inError );

/// The type definition for the completion handler.
typedef void ( ^CTExposureDetectionContactHandler )( NSArray <CTContactInfo *> * _Nullable inContacts, NSError * _Nullable inError );

/// Performs exposure detection bad on previously collected proximity data and keys.
@interface CTExposureDetectionSession : NSObject

/// This property holds the the dispatch queue used to invoke handlers on. If this property isn’t set, the framework uses the main queue.
@property dispatch_queue_t dispatchQueue;

/// This property contains the maximum number of keys to provide to this API at once. This property’s value updates after each operation complete and before the completion handler is invoked. Use this property to throttle key downloads to avoid excessive buffering of keys in memory.
@property (readonly, nonatomic) NSInteger maxKeyCount;

/// Activates the session and requests authorization for the app with the user. Properties and methods cannot be used until this completes successfully.
- (void) activateWithCompletion:(nullable CTErrorHandler) inCompletion;

/// Invalidates the session. Any outstanding completion handlers will be invoked with an error. The session cannot be used after this is called. A new session must be created if another detection is needed.
- (void) invalidate;

/// Asynchronously adds the specified keys to the session to allow them to be checked for exposure. Each call to this method must include more keys than specified by the current value of <maxKeyCount>.
- (void) addPositiveDiagnosisKeys:(NSArray <CTDailyTracingKey *> *) inKeys completion:(nullable CTErrorHandler) inCompletion;

/// Indicates all of the available keys have been provided. Any remaining detection will be performed and the completion handler will be invoked with the results.
- (void) finishedPositiveDiagnosisKeysWithCompletion:(nullable CTExposureDetectionFinishHandler) inFinishHandler;

/// Obtains information on each incident. This can only be called once the detector finishes. The handler may be invoked multiple times. An empty array indicates the final invocation of the hander.
- (void) getContactInfoWithHandler:(nullable CTExposureDetectionContactHandler) inHandler;

@end

NS_ASSUME_NONNULL_END
