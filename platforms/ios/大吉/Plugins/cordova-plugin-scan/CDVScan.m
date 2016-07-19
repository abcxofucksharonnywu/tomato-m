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


#import <Cordova/CDVViewController.h>
#import "CDVScan.h"
#import "CDVScanViewController.h"
@interface CDVScan () {
    CDVInvokedUrlCommand *_command;
}
@end

@implementation CDVScan
-(void)pluginInitialize{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScan:) name:@"scan" object:nil];
}

-(void)handleScan:(NSNotification*)ns{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ns.userInfo[@"content"]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
}


- (void)recognize:(CDVInvokedUrlCommand*)command
{
    _command = command;
    UINavigationController *navController =[[UINavigationController alloc] initWithRootViewController:[[CDVScanViewController alloc] init]];
    [navController.navigationBar setBarTintColor:[UIColor colorWithRed:253/255.f green:28/255.f blue:122/255.f alpha:1]];
    [navController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [navController.navigationBar setTintColor:[UIColor whiteColor]];
    [navController.navigationBar setTranslucent:NO];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:navController animated:YES completion:NULL];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
