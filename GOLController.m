//
//  GOLController.m
//  Game of Life
//
//  Created by Cody Brimhall on 3/23/08.
//  Copyright 2008 Cody Brimhall. All rights reserved.
//

#import "GOLController.h"
#import "GOLGameView.h"
#import "GOLBooleanStringTransformer.h"


const GOLGameSpeed GOLGameSpeedSlow = 1.0;
const GOLGameSpeed GOLGameSpeedNormal = 0.5;
const GOLGameSpeed GOLGameSpeedFast = 0.1;

NSString *GOLStartStopTitleTransformer = @"GOLStartStopTitleTransformer";
NSString *GOLStartGameButtonTitle = @"Start Game";
NSString *GOLStopGameButtonTitle = @"Stop Game";

@implementation GOLController

@synthesize gameInProgress, gameSpeed, gameSpeedIndex;

#pragma mark NSApplication Delegate Methods

+ (void)initialize {
	GOLBooleanStringTransformer *transformer = [GOLBooleanStringTransformer transformerWithYesString:GOLStopGameButtonTitle noString:GOLStartGameButtonTitle];
	
	// Register the value transformer for the start/stop game button
	[NSValueTransformer setValueTransformer:transformer forName:GOLStartStopTitleTransformer];
}

#pragma mark Initialization Methods

- (void)awakeFromNib {
	NSNumber *slow, *normal, *fast;
	
	// Add the slow, normal, and fast values to an array whose indices correspond to the ordering of the items in the speed pop-up menu
	slow = [NSNumber numberWithDouble:GOLGameSpeedSlow];
	normal = [NSNumber numberWithDouble:GOLGameSpeedNormal];
	fast = [NSNumber numberWithDouble:GOLGameSpeedFast];
	
	speedsArray = [[NSArray alloc] initWithObjects:slow, normal, fast, nil];
	self.gameSpeedIndex = 1;
	self.gameSpeed = GOLGameSpeedNormal;
}

#pragma mark Actions

- (IBAction)startStopBoard:(id)sender {
	if(self.gameInProgress)
		[self stopBoard:self];
	else
		[self startBoard:self];
}

- (IBAction)startBoard:(id)sender {
	if(self.gameInProgress)
		return;
	
	// Make sure we don't end up with multiple timers firing off
	if(gameTimer != nil)
		[self stopTimer];
	
	// Kick off the game by advancing a turn immediately and setting a timer to do the rest
	[gameView advance:nil];
	[self startTimer];
	
	self.gameInProgress = YES;
}

- (IBAction)stopBoard:(id)sender {
	// Don't do a thing unless a game is in progress
	if(!self.gameInProgress)
		return;
	
	self.gameInProgress = NO;
	[self stopTimer];
}

- (IBAction)resetBoard:(id)sender {
	// Stop any game in progress
	if(self.gameInProgress)
		[self stopBoard:self];
	
	[gameView resetCells];
}

- (IBAction)advanceBoard:(id)sender {
	[gameView advance:nil];
}

- (IBAction)changeSpeed:(id)sender {
	NSInteger newSpeedIndex = [sender indexOfSelectedItem];
	
	if(self.gameSpeedIndex == newSpeedIndex)
		return;
	
	self.gameSpeedIndex = newSpeedIndex;
	
	if(self.gameInProgress) {
		[self stopTimer];
		[self startTimer];
	}
}

#pragma mark Timing Methods

- (void)startTimer {
	GOLGameSpeed currentSpeed = [[speedsArray objectAtIndex:self.gameSpeedIndex] doubleValue];
	gameTimer = [NSTimer scheduledTimerWithTimeInterval:currentSpeed target:gameView selector:@selector(advance:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
	[gameTimer invalidate];
	gameTimer = nil;
}

@end
