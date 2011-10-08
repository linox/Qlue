//
//  QuizBrain.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizBrain.h"

@implementation QuizBrain
@synthesize questions, correctAnswers,wrongAnswers;
@synthesize pos;

- (BOOL) advancePosition {
	
	if (self.pos < self.numberOfQuestions) {
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

//Fixme: Perhaps use (id) instead of NSString?
- (NSString *) questionAtIndex: (NSInteger) index {

	return [questions objectAtIndex:index];
	
}

- (id) initWithQuestions:(NSMutableArray *)qArray andAnswers:(NSMutableArray *)aArray {
	
	if (self = [super init]) {
		questions = qArray;
		[questions retain];
		
		answers = aArray;
		[answers retain];
	}
	NSLog(@"initWithQuestions: %@", [questions objectAtIndex:0]);
	
	return self;
}

- (void) checkQuestionAtIndex:(NSInteger)q WithAnswer:(NSInteger)a {
	
	if (q == a) {
		[self increaseCorrectScore];
		NSLog(@"Correct!");
	} else {
		[self increaseWrongScore];
		NSLog(@"Wrong!");
	}
}


- (void) checkQuestionAtIndex:(NSInteger) q WithStringAnswer:(NSString *) aStr {
	NSLog(@"aStr=%@, q=%i, i=%i", aStr,q, [answers indexOfObject:aStr]);
	[self checkQuestionAtIndex:q WithAnswer:[answers indexOfObject:aStr]]; // FIXME: add some checking (ie NSNotFound)
	
}

- (void) dealloc {
	[questions release];
	[answers release];
	[super dealloc];

}

@end
