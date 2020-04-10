#import <Foundation/Foundation.h>


@class CTSelfTracingInfo;


NS_ASSUME_NONNULL_BEGIN

/// The type definition for the completion handler.
typedef void ( ^CTSelfTracingInfoGetCompletion ) ( CTSelfTracingInfo * _Nullable inInfo, NSError * _Nullable inError );

/// Requests the daily tracing keys used by this device to share with a server.
@interface CTSelfTracingInfoRequest : NSObject

/// This property invokes this completion handler when the request completes and clears the property to break any potential retain cycles.
@property (nullable, copy) CTSelfTracingInfoGetCompletion completionHandler;

/// This property holds the the dispatch queue used to invoke handlers on. If this property isn’t set, the framework uses the main queue.
@property (nullable) dispatch_queue_t dispatchQueue;

/// Asynchronously performs the request to get the state, and invokes the completion handler when it's done.
- (void) perform;

/// Invalidates a previously initiated request. If there is an outstanding completion handler, the framework will invoke it with an error.
/// Don’t reuse the request after this is called. If you require another request, create a new one.
- (void) invalidate;

@end

NS_ASSUME_NONNULL_END
