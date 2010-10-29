//
//  iphone2websocketViewController.m
//  iphone2websocket
//
//  Created by Manuel Gottstein and Dominik Guzei on 06.10.10.
//  Copyright FH SAlzburg, MMT2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectingViewController.h"

@class ConnectingViewController;

@interface HandshakeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ConnectingViewController *connectingViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ConnectingViewController *connectingViewController;

@end

