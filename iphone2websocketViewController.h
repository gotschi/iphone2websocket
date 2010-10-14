//
//  iphone2websocketViewController.m
//  iphone2websocket
//
//  Created by Manuel Gottstein and Dominik Guzei on 06.10.10.
//  Copyright FH SAlzburg, MMT2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Zimt/Zimt.h"

@interface iphone2websocketViewController : UIViewController < ZTWebSocketDelegate > {

	ZTWebSocket* webSocket;
	
	IBOutlet UILabel *connectStatus;
	IBOutlet UIButton *connectButton;
	IBOutlet UITextField *ipadressTextfield;
	IBOutlet UITextField *gameID;
	IBOutlet UITextField *gamerID;
	
}

-(IBAction) connect;

@end

