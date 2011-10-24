//
//  QAMultiChoiceQuestion.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QAMultiChoiceQuestion.h"


@implementation QAMultiChoiceQuestion
@synthesize Question; // DEBUG: Perhaps better to synthesize questionString = Question? 

- (id) initWithQuestion:(NSString *) q {
	
	if (self = [self initWithQuestion:q andAnswer:nil]) {
		
	}
	
	return self;
}




- (id) initWithQuestion:(NSString *) q andAnswer:(NSString *) a {
	
	if (self = [super init]) {
		//initialize ivars...
		Question = [q copy];
		falseAnswers = [[NSMutableArray alloc] init];
		trueAnswers = [[NSMutableArray alloc] init];
		
		if (a != nil) {
			[trueAnswers addObject:a];
		}
	}
	return self;
}


- (void) addChoice:(NSString*) aStr withBoolValue:(BOOL) isAnswer {

	if (isAnswer) {
		[trueAnswers addObject:aStr];
	} else {
		[falseAnswers addObject:aStr];
	}

}


- (BOOL) checkAnswer:(NSString*) anAnswer {
	//if anAnswer is found in the trueAnswer array it is a correct answer
	NSInteger i = [trueAnswers indexOfObject:anAnswer];
	NSLog(@"i = %d", i);
	if (i != NSNotFound) {
		NSLog(@"%@ is an answer!", anAnswer);
		return YES;
	}
	NSLog(@"%@ is NOT an answer!", anAnswer);
	return NO;
	
}

// DEBUG: remember to memory manage!
// and to check the size of return array which can be less than tc+fc;
- (NSMutableArray*) getAnswerArrayWithTrueCount:(NSInteger) tc andFalseCount:(NSInteger) fc {

	NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];

	//do some bounds checking...
	if (tc > [trueAnswers count]){
		tc = [trueAnswers count];
	}
		
	
	if (fc > [falseAnswers count]){
		fc = [falseAnswers count];
	}
	
	int i;
	
	for (i = 0; i < tc; i++) {
		[retval addObject:[trueAnswers objectAtIndex:i]];
	}
	
	for (i = 0; i < fc; i++) {
		[retval addObject:[falseAnswers objectAtIndex:i]];
	}
	
	return retval;
}

- (void) dealloc {
	[Question release];
	[trueAnswers release];
	[falseAnswers release];
	[super dealloc];
}
@end
