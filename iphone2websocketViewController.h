//
//  iphone2websocketViewController.h
//  iphone2websocket
//
//  Created by Manuel Gottstein on 06.10.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iphone2websocketViewController : UIViewController {
	
	int value;
	
	IBOutlet UIButton *myButton;
	IBOutlet UILabel *myLabel;
	IBOutlet UISlider *mySlider;

}

- (IBAction) setMyLabel;

@end

