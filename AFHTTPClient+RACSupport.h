// AFHTTPClient+RACSupport.h
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

#import <AFNetworking/AFNetworking.h>

@class RACSignal;

@interface AFHTTPClient (RACSupport)

// Enqueues an AFHTTPRequestOperation and returns a signal.
//
// requestOperation - The request operation to enqueue.
//
// The returned signal sends a tuple of ((AFHTTPRequestOperation *)operation,
// (id)responseObject), then completes.
- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation;

// Enqueues an AFHTTPRequestOperation created from `urlRequest` and returns a
// signal.
//
// urlRequest - The request used to create a request operation.
//
// The returned signal sends a tuple of ((AFHTTPRequestOperation *)operation,
// (id)responseObject), then completes.
- (RACSignal *)rac_enqueueHTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest;

// Enqueues a set of AFHTTPRequestOperation into a batch and returns a signal.
//
// requestOperations - The request operations to enqueue.
//
// The returned signal sends a tuple of ((AFHTTPRequestOperation *)operation,
// (id)responseObject), then completes.
- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperations:(NSArray *)requestOperations;

// Enqueues a set of AFHTTPRequestOperation, created from the given requests,
// into a batch and returns a signal.
//
// urlRequest - The requests used to create request operations.
//
// The returned signal sends a tuple of ((AFHTTPRequestOperation *)operation,
// (id)responseObject), then completes.
- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperationsWithRequests:(NSArray *)urlRequests;

@end
