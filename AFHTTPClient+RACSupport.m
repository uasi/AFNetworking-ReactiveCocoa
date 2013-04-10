// AFHTTPClient+RACSupport.m
// AFNetworking-ReactiveCocoa
//
// The MIT License (MIT)
//
// Copyright (c) 2013 Tomoki Aonuma <uasi@uasi.jp>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPClient+RACSupport.h"
#import "AFHTTPRequestOperation+RACSupport.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation AFHTTPClient (RACSupport)

#pragma mark - 

- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation
{
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [requestOperation rac_setCompletionBlockWithSubject:subject];
    [self enqueueHTTPRequestOperation:requestOperation];
    return subject;
}

- (RACSignal *)rac_enqueueHTTPRequestOperationWithRequest:(NSURLRequest *)URLRequest
{
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:URLRequest success:NULL failure:NULL];
    return [self rac_enqueueHTTPRequestOperation:requestOperation];
}

- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperations:(NSArray *)requestOperations
{
    RACSignal *signal = [RACSignal merge:[[requestOperations rac_sequence] map:^(AFHTTPRequestOperation *requestOperation) {
        RACSubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
        [requestOperation rac_setCompletionBlockWithSubject:subject];
        return subject;
    }]];

    [self enqueueBatchOfHTTPRequestOperations:requestOperations progressBlock:NULL completionBlock:NULL];

    return signal;
}

- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperationsWithRequests:(NSArray *)urlRequests
{
    NSArray *requestOperations = [[[urlRequests rac_sequence] map:^(NSURLRequest *urlRequest) {
        return [self HTTPRequestOperationWithRequest:urlRequest success:NULL failure:NULL];
    }] array];
    return [self rac_enqueueBatchOfHTTPRequestOperations:requestOperations];
}

#pragma mark -

- (RACSignal *)rac_getPath:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self rac_enqueueRequestWithMethod:@"GET" path:path parameters:parameters];
}

- (RACSignal *)rac_postPath:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self rac_enqueueRequestWithMethod:@"POST" path:path parameters:parameters];
}

- (RACSignal *)rac_putPath:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self rac_enqueueRequestWithMethod:@"PUT" path:path parameters:parameters];
}

- (RACSignal *)rac_deletePath:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self rac_enqueueRequestWithMethod:@"DELETE" path:path parameters:parameters];
}

- (RACSignal *)rac_patchPath:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self rac_enqueueRequestWithMethod:@"PATCH" path:path parameters:parameters];
}

- (RACSignal *)rac_enqueueRequestWithMethod:(NSString *)method
                                       path:(NSString *)path
                                 parameters:(NSDictionary *)parameters
{
    NSURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    return [self rac_enqueueHTTPRequestOperationWithRequest:request];
}

@end
