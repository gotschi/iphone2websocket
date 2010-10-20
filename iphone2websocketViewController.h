//
//  iphone2websocketViewController.m
//  iphone2websocket
//
//  Created by Manuel Gottstein and Dominik Guzei on 06.10.10.
//  Copyright FH SAlzburg, MMT2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Zimt/Zimt.h"
#import <CoreMotion/CoreMotion.h>

@interface iphone2websocketViewController : UIViewController < ZTWebSocketDelegate, UITextFieldDelegate, UIAccelerometerDelegate, UITextFieldDelegate > {

	ZTWebSocket* webSocket;
	
	NSString *ipAdress;
	IBOutlet UILabel *accelStatus;
	IBOutlet UILabel *gyroStatus;
	IBOutlet UILabel *connectStatus;
	IBOutlet UIButton *connectButton;
	IBOutlet UITextField *ipadressTextfield;
	IBOutlet UITextField *gameID;
	IBOutlet UITextField *gamerID;
	IBOutlet UIButton *gyroButton;
	CMMotionManager *motionManager;
    NSOperationQueue *opQ;
	
	
}

-(IBAction) connect;

-(IBAction) activateAccel;

-(IBAction) activateGyro;

-(IBAction) sendHello;

@end

