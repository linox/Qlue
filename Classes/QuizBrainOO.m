//
//  QuizBrainOO.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizBrainOO.h"


@implementation QuizBrainOO
@synthesize questions, correctAnswers,wrongAnswers;
@synthesize pos;

- (id) initWithQuestions:(NSMutableArray *)qArray {
	
	if (self = [super init]) {
		self.questions = qArray; //qArray is retained
	}
	
	NSLog(@"initWithQuestions: %@", [questions objectAtIndex:0]);//DEBUG:
	
	return self;
}

- (BOOL) advancePosition {
	
	if (self.pos < [self numberOfQuestions]-1) {
		self.pos++;
		return YES;
	}
	
	return NO;
	
}

- (void) reset {
	self.pos = 0;
	self.correctAnswers = 0;
	self.wrongAnswers = 0;
}

- (void) increaseCorrectScore {
	correctAnswers++;
}

- (void) increaseWrongScore {
	wrongAnswers++;
}

- (NSInteger) numberOfQuestions {
	
	return [questions count];
	
}

- (QAMultiChoiceQuestion *) questionAtIndex: (NSInteger) index {
	
	return [questions objectAtIndex:index];
	
}

- (QAMultiChoiceQuestion *) questionAtCurrentPosition {
	
	return [questions objectAtIndex:self.pos];
	
}
- (void) checkQuestion:(NSString *) aStr {

	if ([[self questionAtCurrentPosition] checkAnswer:aStr]) {
		[self increaseCorrectScore];
	} else {
		[self increaseWrongScore];
	}
}

- (void) dealloc {
	[questions release];
	[super dealloc];
}


@end
