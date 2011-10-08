//
//  QAQuestion.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QAQuestion.h"


@implementation QAQuestion

@synthesize Question, Answer;

- (id) initWithQuestion:(NSString *) q andAnswer:(NSString *) a {
	if (self = [super init]) {
		self.Answer = a;
		self.Question = q;
	}
	return self;
}


- (BOOL) isAnswer:(NSString *) anAnswer {

	if([anAnswer isEqual:self.Answer]) {
		return YES;
		
	}
	
	return NO;
}

- (void) dealloc {

	[super dealloc];
}

@end
