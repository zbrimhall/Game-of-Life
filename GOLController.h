//
//  GOLController.h
//  Game of Life
//
//  Created by Cody Brimhall on 3/23/08.
//  Copyright 2008 Cody Brimhall. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef NSTimeInterval GOLGameSpeed;
extern const GOLGameSpeed GOLGameSpeedSlow;
extern const GOLGameSpeed GOLGameSpeedNormal;
extern const GOLGameSpeed GOLGameSpeedFast;

extern NSString *GOLStartStopTitleTransformer;
extern NSString *GOLStartGameButtonTitle;
extern NSString *GOLStopGameButtonTitle;

@class GOLGameView;

@interface GOLController : NSObject {
	IBOutlet GOLGameView *gameView;
	IBOutlet NSButton *startStopButton;
	
	NSTimer *gameTimer;
	NSArray *speedsArray;
	NSInteger gameSpeedIndex;
	
	BOOL gameInProgress;
	GOLGameSpeed gameSpeed;
}

@property(readwrite) BOOL gameInProgress;
@property(readwrite) GOLGameSpeed gameSpeed;
@property(readwrite) NSInteger gameSpeedIndex;

// Actions
- (IBAction)startStopBoard:(id)sender;
- (IBAction)startBoard:(id)sender;
- (IBAction)stopBoard:(id)sender;
- (IBAction)resetBoard:(id)sender;
- (IBAction)advanceBoard:(id)sender;
- (IBAction)changeSpeed:(id)sender;

// Timing Methods
- (void)startTimer;
- (void)stopTimer;
@end
