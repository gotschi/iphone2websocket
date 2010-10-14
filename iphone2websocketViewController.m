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
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = 20.0f;
}

- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)aceler
{
	// ACCEL
	[webSocket send: [NSString stringWithFormat:@"%f/%f/%f",aceler.x, aceler.y, aceler.z]];
}

-(void) sendHello {
	[webSocket send: @"Hallo!"];
}

- (void) activateAccel {
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	
	if (accel.updateInterval == 1.0f/60.0f) {
		accel.updateInterval= 20.0f;
		[connectStatus setText:@"20s"];
	}

	else {
		accel.updateInterval = 1.0f/60.0f;
		[connectStatus setText:@"1/60"];
		
	}
	
	
}

-(void) connect {
	
		NSString *myString = [NSString stringWithFormat:@"%@%@%@", @"ws://10.254.0.53:10000/", gameID.text, @"/connect"];
		
		webSocket = [[ZTWebSocket alloc] initWithURLString:myString delegate:self];
		
		if (!webSocket.connected) {
			[webSocket open];
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
		[connectStatus setText:message];
}

-(void)webSocketDidOpen:(ZTWebSocket *)aWebSocket {
	
}

-(void)webSocketDidClose:(ZTWebSocket *)webSocket {
	
    [connectButton setTitle:@"Connect" forState:UIControlStateNormal];
	
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
