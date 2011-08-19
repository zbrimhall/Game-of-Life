//
//  GOLBooleanStringTransformer.h
//  Game of Life
//
//  Created by Cody Brimhall on 3/24/08.
//  Copyright 2008 Cody Brimhall. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GOLBooleanStringTransformer : NSValueTransformer {
	NSString *yesString, *noString;
}
+ (id)transformerWithYesString:(NSString *)newYesString noString:(NSString *)newNoString;

- (id)initWithYesString:(NSString *)newYesString noString:(NSString *)newNoString;
@end
