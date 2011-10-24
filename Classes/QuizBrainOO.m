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
@synthesize savedScore;
@synthesize title, json, ID;
@synthesize depends;

- (id) initWithQuestions:(NSMutableArray *)qArray {
	
	if (self = [super init]) {
		self.questions = qArray; //qArray is retained
	}
	
	score = [[NSMutableArray alloc] init];
	int i;
	for (i=0; i< [qArray count]; i++) {
		[score addObject:[NSNumber numberWithInt:0]];
	}
	
	NSLog(@"initWithQuestions: %@, antal questions=%d", [questions objectAtIndex:0], [questions count]);//DEBUG:
	
	return self;
}

- (BOOL) advancePosition {
	
	if (self.pos < [self numberOfQuestions]-1) {
		self.pos++;
		return YES;
	}
	
	return NO;
	
}

- (BOOL) decreasePosition {
	
	if (self.pos > 0 ) {
		self.pos--;
		return YES;
	}
	
	return NO;
	
}


- (BOOL) setPosition:(NSInteger) newpos{
	if(newpos<0) {return NO;}
	
	if (newpos < [self numberOfQuestions]) {
		self.pos = newpos;
		return YES;
	}
	
	return NO;
	
}


- (void) reset {
	self.pos = 0;
	self.correctAnswers = 0;
	self.wrongAnswers = 0;
}
// Returns the sum of correct answers in the quiz.
// If a question is answered with two answers and on is right and the other is wrong, we count that answer as wrong.
- (NSNumber *) getScore {
	NSNumber *s;
	
	int val = 0;
	for (s in score) {
		//Dont count the score if theres a wrong answer in the question. Wronganswers makes intValue become < 0
		if ([s intValue] > 0) {
		val = val + [s intValue];
		}
	}

	return [NSNumber numberWithInt:val];// FIXME: LEEEEEEK??!!
}

- (void) resetScoreAtCurrentPos {
	
	[score replaceObjectAtIndex:pos withObject:[NSNumber numberWithInt:0]];
}

- (void) increaseCorrectScore {
	correctAnswers++;
	int val = [[score objectAtIndex:pos] intValue];
	[score replaceObjectAtIndex:pos withObject:[NSNumber numberWithInt:val + 1]];
}

- (void) increaseWrongScore {
	wrongAnswers++;
	[score replaceObjectAtIndex:pos withObject:[NSNumber numberWithInt:-99]];//FIXME: Use two scoreArrays for right and wrong!
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
- (void) checkQuestion:(NSString *) aStr withCondition:(BOOL) c {

	if ([[self questionAtCurrentPosition] checkAnswer:aStr] == c ) {
		[self increaseCorrectScore];
	} else {
		[self increaseWrongScore];
	}
}

- (BOOL) isAnswer:(NSString *) aStr {
	return [[self questionAtCurrentPosition] checkAnswer:aStr];
}

- (void) dealloc {
	[score release];
	[questions release];
	[super dealloc];
}


@end
