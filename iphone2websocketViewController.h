//
//  iphone2websocketViewController.m
//  iphone2websocket
//
//  Created by Manuel Gottstein and Dominik Guzei on 06.10.10.
//  Copyright FH SAlzburg, MMT2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Zimt/Zimt.h"

@interface iphone2websocketViewController : UIViewController < ZTWebSocketDelegate, UITextFieldDelegate, UIAccelerometerDelegate > {

	ZTWebSocket* webSocket;
	
	IBOutlet UILabel *connectStatus;
	IBOutlet UIButton *connectButton;
	IBOutlet UITextField *ipadressTextfield;
	IBOutlet UITextField *gameID;
	IBOutlet UITextField *gamerID;
	
}

-(IBAction) connect;

-(IBAction) activateAccel;

-(IBAction) sendHello;

-(IBAction)textFieldDoneEditing:(id)sender;

@end

