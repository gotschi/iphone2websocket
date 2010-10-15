//
//  iphone2websocketViewController.m
//  iphone2websocket
//
//  Created by Manuel Gottstein and Dominik Guzei on 06.10.10.
//  Copyright FH SAlzburg, MMT2010. All rights reserved.
//

#import "iphone2websocketViewController.h"

@implementation iphone2websocketViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	motionManager = [[CMMotionManager alloc] init];  // Gyroscope (iphone 4)+
	
}

- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)aceler
{
	// Accelerator sends x,y,z 60 times / second
	[webSocket send: [NSString stringWithFormat:@"%@/%f/%f/%f", @"ACCEL", aceler.x, aceler.y, aceler.z]];
	//[connectStatus setText:[NSString stringWithFormat:@"%@/%f/%f/%f", @"ACCEL", aceler.x, aceler.y, aceler.z]];
}

-(void) sendHello { // DEBUG
	[webSocket send: @"Hallo!"];
}

- (void) activateAccel {
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	if(accel.delegate != self) {
		//[webSocket send:@"ACCEL"];
		
		accel.delegate = self;
	}
	
	else {
		accel.delegate = nil;
		[webSocket send: [NSString stringWithFormat:@"%@/%f/%f/%f", @"ACCEL", 0, 0, 0 ]];
	}
	
}

-(void) activateGyro { // Gyroscope
	
	if(motionManager.gyroUpdateInterval == 1.0f/60.0f) {
		
		motionManager.gyroUpdateInterval = 1000.0f;
		
		[webSocket send: [NSString stringWithFormat:@"%@/%f/%f/%f", @"GYRO", 0, 0, 0]];
		
	}

	else motionManager.gyroUpdateInterval = 1.0f/60.0f;
	
    [motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                               withHandler: ^(CMGyroData *gyroData, NSError *error)
	 {
		 CMRotationRate rotate = gyroData.rotationRate;
		 [webSocket send: [NSString stringWithFormat:@"%@/%f/%f/%f", @"GYRO", rotate.x, rotate.y, rotate.z]];
	 }];
	
}

-(void) connect {
	if(!webSocket) {
		//Connect to IP in textfield, with gameID
		NSString *cString = [NSString stringWithFormat:@"%@%@%@%@%@", @"ws://", ipadressTextfield.text, @":10000/", gameID.text, @"/connect"];
		
		// start Websocket
		webSocket = [[ZTWebSocket alloc] initWithURLString:cString delegate:self];
		
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
		//[connectStatus setText:message]; // DEBUG
		[gamerID setText:message]; // Set GamerID
}

-(void)webSocketDidOpen:(ZTWebSocket *)aWebSocket {
	[connectStatus setText:@"Connected!"];
}

-(void)webSocketDidClose:(ZTWebSocket *)webSocket {
	[connectStatus setText:@"disconnected"];
}

-(void)webSocketDidSendMessage:(ZTWebSocket *)webSocket {
	
}

-(IBAction)textFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
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
