//
//  QuizBrain.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizBrain : NSObject {
	NSMutableArray *questions;
	NSMutableArray *answers;
	
	NSInteger correctAnswers;
	NSInteger wrongAnswers;
	NSInteger pos;

}

- (id) initWithQuestions:(NSMutableArray *) qArray andAnswers:(NSMutableArray *) aArray;
- (void) checkQuestionAtIndex:(NSInteger) q WithAnswer:(NSInteger) a;
- (void) checkQuestionAtIndex:(NSInteger) q WithStringAnswer:(NSString *) aStr;
- (NSString *) questionAtIndex: (NSInteger) index;


- (NSInteger) numberOfQuestions;

- (void) increaseCorrectScore;
- (void) increaseWrongScore;
- (BOOL) advancePosition;
- (void) reset;

@property (nonatomic, assign) NSMutableArray *questions;//Fixme: Use retain instead of assign?
@property (nonatomic, assign) NSInteger correctAnswers;
@property (nonatomic, assign) NSInteger wrongAnswers;
@property (nonatomic, assign) NSInteger pos;

@end
