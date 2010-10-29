//
//  iphone2websocketViewController.m
//  iphone2websocket
//
//  Created by Manuel Gottstein and Dominik Guzei on 06.10.10.
//  Copyright FH SAlzburg, MMT2010. All rights reserved.
//

#import "ConnectingViewController.h"

@implementation ConnectingViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[ipadressTextfield setDelegate:self];
	[gameID setDelegate:self];
	motionManager = [[CMMotionManager alloc] init];  // Gyroscope (iphone 4)+
	
}

- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)aceler
{
	// Accelerator sends x,y,z 60 times / second
	[webSocket send: [NSString stringWithFormat:@"game %@/%f/%f/%f", @"ACCEL", aceler.x, aceler.y, aceler.z]];
}

- (void) activateAccel {
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	if(accel.delegate != self) {
		//[webSocket send:@"ACCEL"];
		
		accel.delegate = self;
		accel.updateInterval = 1.0f/24.0f;
	}
	
	else {
		accel.delegate = nil;
		[webSocket send: [NSString stringWithFormat:@"game %@/%f/%f/%f", @"ACCEL", 0, 0, 0 ]];
	}
	
}

-(void) activateGyro { // Gyroscope
	/*
	if(gyroStatus.text==@"On") {
		
		[motionManager stopGyroUpdates];
		[webSocket send: [NSString stringWithFormat:@"game %@/%f/%f/%f", @"GYRO", 0, 0, 0]];
		[gyroStatus setText: @"Off"];
		
	}

	else {
		
		[gyroStatus setText: @"On"];
		motionManager.gyroUpdateInterval = 1.0f/30.0f;
		
		
		[motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
								   withHandler: ^(CMGyroData *gyroData, NSError *error)
		 {
			 CMRotationRate rotate = gyroData.rotationRate;
			 [webSocket send: [NSString stringWithFormat:@"game %@/%f/%f/%f", @"GYRO", rotate.x, rotate.y, rotate.z]];
			 
		 }];
	}
	*/
}

-(void) connect {
	// Determine Device for identification
	NSString *deviceType = [UIDevice currentDevice].model;
	if(!webSocket) {		
		// clean up spaces in url and replace them with "-"
		deviceType = [deviceType stringByReplacingOccurrencesOfString:@" " withString:@"-"];
		//Connect to IP in textfield, with gameID
		NSString *cString = [NSString stringWithFormat:@"ws://%@%@%@%@%@", ipadressTextfield.text, @":10000/", gameID.text, @"/connect/", deviceType];
		
		// start Websocket
		@try {
			webSocket = [[ZTWebSocket alloc] initWithURLString:cString delegate:self];
			//webSocket = [[ZTWebSocket alloc] initWithURLString:@"ws://" delegate:self];
		}
		@catch (NSException* ex) {
			[connectStatus setText:[NSString stringWithFormat:@"%@", ex]];
		}

		// open Websocket
		if (!webSocket.connected) {
			[webSocket open];
			[connectButton setTitle:@"DisConnect" forState:UIControlStateNormal];
		}
		
	}
	else {
		[webSocket release];
		webSocket = 0;
		[connectButton setTitle:@"Connect" forState:UIControlStateNormal];
		[connectStatus setText:@"disconnected"];
	}
}

-(void)webSocket:(ZTWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (error.code == ZTWebSocketErrorConnectionFailed) {
        [connectStatus setText:@"Connection failed"];
    } else if (error.code == ZTWebSocketErrorHandshakeFailed) {
        [connectStatus setText:@"Handshake failed"];
    } else {
        [connectStatus setText:@"Error"];
    }
}

-(void)webSocket:(ZTWebSocket *)webSocket didReceiveMessage:(NSString*)message {
	// analyize message and do appropriate action
	[gamerID setText:[NSString stringWithFormat:@"your gamer ID: %@", message]]; // Set GamerID
	[self activateAccel];
}

-(void)webSocketDidOpen:(ZTWebSocket *)aWebSocket {
	[connectStatus setText:@"Connected!"];
}

-(void)webSocketDidClose:(ZTWebSocket *)webSocket {
	
}

-(void)webSocketDidSendMessage:(ZTWebSocket *)webSocket {
	
}

-(BOOL) textFieldShouldReturn:(UITextField *)tf {
    switch (tf.tag) {
        case 1:
            [gameID becomeFirstResponder];
            break;
        case 2:
			[gameID resignFirstResponder];
			return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)dealloc {
    [webSocket release];
    [super dealloc];
}

@end
