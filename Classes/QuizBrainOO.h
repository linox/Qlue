//
//  QuizBrainOO.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAMultiChoiceQuestion.h"


@interface QuizBrainOO : NSObject {
	NSMutableArray *questions;
	NSInteger correctAnswers;
	NSInteger wrongAnswers;
	NSInteger pos;
}

- (id) initWithQuestions:(NSMutableArray *) qArray;

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, assign) NSInteger correctAnswers;
@property (nonatomic, assign) NSInteger wrongAnswers;
@property (nonatomic, assign) NSInteger pos;

- (QAMultiChoiceQuestion *) questionAtIndex: (NSInteger) index;
- (QAMultiChoiceQuestion *) questionAtCurrentPosition;
- (NSInteger) numberOfQuestions;
- (void) checkQuestion:(NSString *) aStr;
- (void) increaseCorrectScore;
- (void) increaseWrongScore;
- (BOOL) advancePosition;
- (void) reset;

@end
