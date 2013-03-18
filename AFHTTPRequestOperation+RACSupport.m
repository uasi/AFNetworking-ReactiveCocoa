// AFHTTPRequestOperation+RACSupport.m
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

#import "AFHTTPRequestOperation+RACSupport.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation AFHTTPRequestOperation (RACSupport)

- (void)rac_setCompletionBlockWithSubject:(RACSubject *)subject
{
    [self
     setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         [subject sendNext:RACTuplePack((id)operation, responseObject)];
         [subject sendCompleted];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
         [userInfo setObject:operation forKey:@"AFHTTPRequestOperation"];
         [subject sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:userInfo]];
     }];
}

@end
