//
//  QAMultiChoiceQuestion.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QAMultiChoiceQuestion.h"


@implementation QAMultiChoiceQuestion
@synthesize Question;
@synthesize trueAnswers, falseAnswers;

- (id) initWithQuestion:(NSString *) q andAnswer:(NSString *) a {
	
	if (self = [super init]) {
		//initialize ivars...
		self.Question = q;
		self.falseAnswers = [[NSMutableArray alloc] initWithObjects:nil];
		//add initial answer to the true answer array
		self.trueAnswers = [[NSMutableArray alloc] initWithObjects:a, nil];
	}
	return self;
}


- (void) addChoice:(NSString*) aStr withBoolValue:(BOOL) isAnswer {

	if (isAnswer) {
		[self.trueAnswers addObject:aStr];
	} else {
		[self.falseAnswers addObject:aStr];
	}

}


- (BOOL) checkAnswer:(NSString*) anAnswer {
	//if anAnswer is found in the trueAnswer array it is a correct answer
	NSInteger i = [self.trueAnswers indexOfObject:anAnswer];
	NSLog(@"i = %d", i);
	if (i != NSNotFound) {
		NSLog(@"%@ is an answer!", anAnswer);
		return YES;
	}
	NSLog(@"%@ is NOT an answer!", anAnswer);
	return NO;
	
}

// remember to memory management!
// and to check the size of return array which can be less than tc+fc;
- (NSMutableArray*) getAnswerArrayWithTrueCount:(NSInteger) tc andFalseCount:(NSInteger) fc {

	NSMutableArray *retval = [[NSMutableArray alloc] init];

	//do some bounds checking...
	if (tc > [self.trueAnswers count]){
		tc = [self.trueAnswers count];
	}
		
	
	if (fc > [self.falseAnswers count]){
		fc = [self.falseAnswers count];
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
	[trueAnswers release];
	[falseAnswers release];
	[super dealloc];
}
@end
