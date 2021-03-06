/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#include <sys/types.h>
#include <sys/sysctl.h>
#include "TargetConditionals.h"

#import <Cordova/CDV.h>
#import "CDVFirebase.h"
#import <FirebaseAnalytics/FirebaseAnalytics.h>
@interface CDVFirebase () {}
@end

@implementation CDVFirebase

- (void)log:(CDVInvokedUrlCommand*)command
{
    NSLog(@"log-%@",command);
    NSString *logName = command.arguments[0];
    NSDictionary *params = command.arguments[1];
    [FIRAnalytics logEventWithName:logName parameters:params];
    
}

-(void)store:(CDVInvokedUrlCommand *)command{
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1151418807"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end

