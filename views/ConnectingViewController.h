//
//  iphone2websocketViewController.m
//  iphone2websocket
//
//  Created by Manuel Gottstein and Dominik Guzei on 06.10.10.
//  Copyright FH SAlzburg, MMT2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ConnectingViewController : UIViewController < UITextFieldDelegate, UIAccelerometerDelegate, UITextFieldDelegate > {
	
	NSString *ipAdress;
	IBOutlet UILabel *connectStatus;
	IBOutlet UIButton *connectButton;
	IBOutlet UITextField *ipadressTextfield;
	IBOutlet UITextField *gameID;
	IBOutlet UILabel *gamerID;
	CMMotionManager *motionManager;
    NSOperationQueue *opQ;
	
}

-(IBAction) connect;

@end

