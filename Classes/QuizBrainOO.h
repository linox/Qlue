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
	NSMutableArray *questions;//FIXME: use nonmutable array?...
	NSInteger correctAnswers;
	NSInteger wrongAnswers;
	NSInteger pos;
	NSString *title;
	NSMutableArray *score;
	NSString *json;
	NSInteger savedScore;
	NSMutableDictionary *depends;
	NSString *ID;
}

- (id) initWithQuestions:(NSMutableArray *) qArray;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *json;
@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, assign) NSInteger correctAnswers;
@property (nonatomic, assign) NSInteger wrongAnswers;
@property (nonatomic, assign) NSInteger pos;
@property (nonatomic, assign) NSInteger savedScore;
@property (nonatomic, retain) NSMutableDictionary *depends;
@property (nonatomic, copy) NSString *ID;

- (QAMultiChoiceQuestion *) questionAtIndex: (NSInteger) index;
- (QAMultiChoiceQuestion *) questionAtCurrentPosition;
- (NSInteger) numberOfQuestions;
- (NSNumber *) getScore;
- (BOOL) isAnswer:(NSString *) aStr;
- (void) checkQuestion:(NSString *) aStr withCondition:(BOOL) c;
- (void) increaseCorrectScore;
- (void) increaseWrongScore;
- (BOOL) advancePosition;
- (BOOL) decreasePosition;
- (BOOL) setPosition:(NSInteger) newpos;
- (void) reset;
- (void) resetScoreAtCurrentPos;


@end
