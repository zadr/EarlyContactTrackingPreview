#import <Foundation/Foundation.h>
#import <ContactTracking/CTDefines.h>
#import <ContactTracking/CTManagerState.h>


NS_ASSUME_NONNULL_BEGIN

/// Changes the state of contact tracing on the device.
@interface CTStateSetRequest : NSObject

/// This property holds the completion handler that framework invokes when the request completes. The property is cleared upon completion to break any potential retain cycles.
@property (nullable, copy) CTErrorHandler completionHandler;

/// This property holds the the dispatch queue used to invoke handlers on. If this property isn’t set, the framework uses the main queue.
@property (nullable) dispatch_queue_t dispatchQueue;

/// This property contains the state to set Contact Tracing to. Call the perform method to apply the state once set.
@property (readwrite) CTManagerState state;

/// Asynchronously performs the request to get the state, and invokes the completion handler when it's done.
- (void) perform;

/// Invalidates a previously initiated request. If there is an outstanding completion handler, the framework will invoke it with an error.
/// Don’t reuse the request after this is called. If you require another request, create a new one.
- (void) invalidate;

@end

NS_ASSUME_NONNULL_END
