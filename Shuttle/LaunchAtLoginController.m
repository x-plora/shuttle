//
//  LaunchAtLoginController.m
//
//  Copyright 2011 Tomáš Znamenáček
//  Copyright 2010 Ben Clark-Robinson
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the ‘Software’),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "LaunchAtLoginController.h"
#import <ServiceManagement/ServiceManagement.h>

static NSString *const StartAtLoginKey = @"launchAtLogin";

@implementation LaunchAtLoginController

#pragma mark Launch List Control

- (BOOL) willLaunchAtLogin: (NSURL*) itemURL
{
    return [SMAppService mainAppService].status == SMAppServiceStatusEnabled;
}

- (void) setLaunchAtLogin: (BOOL) enabled forURL: (NSURL*) itemURL
{
    SMAppService *service = [SMAppService mainAppService];
    NSError *error = nil;

    if (enabled) {
        if (service.status != SMAppServiceStatusEnabled) {
            [service registerAndReturnError:&error];
        }
    } else if (service.status != SMAppServiceStatusNotRegistered) {
        [service unregisterAndReturnError:&error];
    }

    if (error) {
        NSLog(@"Unable to update launch at login: %@", error);
    }
}

#pragma mark Basic Interface

- (NSURL*) appURL
{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
}

- (void) setLaunchAtLogin: (BOOL) enabled
{
    [self willChangeValueForKey:StartAtLoginKey];
    [self setLaunchAtLogin:enabled forURL:[self appURL]];
    [self didChangeValueForKey:StartAtLoginKey];
}

- (BOOL) launchAtLogin
{
    return [self willLaunchAtLogin:[self appURL]];
}

@end
