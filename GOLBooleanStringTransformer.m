//
//  GOLBooleanStringTransformer.m
//  Game of Life
//
//  Created by Cody Brimhall on 3/24/08.
//  Copyright 2008 Cody Brimhall. All rights reserved.
//

#import "GOLBooleanStringTransformer.h"


@implementation GOLBooleanStringTransformer

+ (id)transformerWithYesString:(NSString *)newYesString noString:(NSString *)newNoString {
	return [[self alloc] initWithYesString:newYesString noString:newNoString];
}

+ (Class)transformedValueClass {
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
	return NO;
}

- (id)initWithYesString:(NSString *)newYesString noString:(NSString *)newNoString {
	if(![super init])
		return nil;
	
	yesString = newYesString;
	noString = newNoString;
	
	return self;
}

- (id)transformedValue:(id)value {
	return [value boolValue] ? yesString : noString;
}

@end
