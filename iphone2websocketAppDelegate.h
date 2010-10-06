//
//  iphone2websocketAppDelegate.h
//  iphone2websocket
//
//  Created by Manuel Gottstein on 06.10.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
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

