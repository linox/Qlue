//
//  QuizBrainOO.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizBrainOO.h"


@implementation QuizBrainOO



//- (NSInteger) numberOfQuestions {
//	
//	return [questions count];
//	
//}
//
//- (NSString *) questionAtIndex: (NSInteger) index {
//	
//	return [questions objectAtIndex:index];
//	
//}

- (id) initWithQuestions:(NSMutableArray *) qArray {
	//FIXME: Add introspection to check that qArray contains QAMultiChoiceQuestions...
	
	if (self = [super initWithQuestions: qArray andAnswers:nil]) {
		
	}
	
	return self;
}
- (QAMultiChoiceQuestion *) questionAtIndex: (NSInteger) index {
	
	return [questions objectAtIndex:index];
	
}

- (QAMultiChoiceQuestion *) questionAtCurrentPosition{
	
	return [questions objectAtIndex:self.pos-1];
	
}
- (void) checkQuestion:(NSString *) aStr {

	if ([[self questionAtCurrentPosition] checkAnswer:aStr]) {
		[self increaseCorrectScore];
	} else {
		[self increaseWrongScore];
	}
}

//- (void) checkQuestionAtIndex:(NSInteger) q WithStringAnswer:(NSString *) aStr {
//	if ([[self questionAtIndex:q] checkAnswer:aStr]) {
//		[self increaseCorrectScore];
//	} else {
//		[self increaseWrongScore];
//	}
//}

- (void) dealloc {
	[questions release];
	[answers release];
	[super dealloc];
	
}


@end
