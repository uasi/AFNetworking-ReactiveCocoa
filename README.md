AFNetworking-ReactiveCocoa
==========================

AFNetworking-ReactiveCocoa makes AFNetworking reactive.

Install
-------

Add `pod 'AFNetworking-ReactiveCocoa'` in your Podfile.

Synopsis
--------

```objc
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking-ReactiveCocoa/AFNetworking-ReactiveCocoa.h>

- (void)requestAndSubscribe {
  AFHTTPClient *client = ...;
  NSURLRequest *request = ...;

  // Enqueue the request and get a signal.
  RACSignal *signal = [client rac_enqueueHTTPRequestOperationWithRequest:request];

  // Subscribe the signal, which will send a tuple of the request operation
  // and the response object.
  [signal
   subscribeNext:^(RACTuple *tuple) {
     RACTupleUnpack(AFHTTPRequestOperation *operation, id responseObject) = tuple;
     NSLog(@"success: operation=%@, responseObject=%@", operation, responseObject);
  }
   error:^(NSError *error) {
     // The error object is the same one that is passed to the failure handler
     // of the enqueued request operation, except one additional key-value pair
     // in `userInfo` as shown below.
     AFHTTPRequestOperation *operation = [error.userInfo objectForKey:@"AFHTTPRequestOperation"];
     NSLog(@"error: operation=%@", operation);
   }
   completed:^{
     NSLog(@"completed");
   }];
}
```

Description
-----------

AFNetworking-ReactiveCocoa adds these methods:

```objc
@interface AFHTTPClient (RACSupport)

- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation;
- (RACSignal *)rac_enqueueHTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest;

- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperations:(NSArray *)requestOperations;
- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperationsWithRequests:(NSArray *)urlRequests;

- (RACSignal *)rac_getPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_postPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_putPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_deletePath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_patchPath:(NSString *)path parameters:(NSDictionary *)parameters;

@end

@interface AFHTTPRequestOperation (RACSupport)

- (void)rac_setCompletionBlockWithSubject:(RACSubject *)subject;

@end
```

See header files for the detailed documentation.
