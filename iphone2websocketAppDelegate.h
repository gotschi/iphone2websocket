//
//  iphone2websocketViewController.m
//  iphone2websocket
//
//  Created by Manuel Gottstein and Dominik Guzei on 06.10.10.
//  Copyright FH SAlzburg, MMT2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iphone2websocketViewController;

@interface iphone2websocketAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iphone2websocketViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iphone2websocketViewController *viewController;

@end

