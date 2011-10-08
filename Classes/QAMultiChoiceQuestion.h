//
//  QAMultiChoiceQuestion.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAMultiChoiceQuestion : NSObject {

	NSString *Question;
	NSMutableArray *trueAnswers; //more than one answer can be true, so use an array instead of single string.
	NSMutableArray *falseAnswers;
}

- (id) initWithQuestion:(NSString *) q andAnswer:(NSString *) a;
- (void) addChoice:(NSString*) aStr withBoolValue:(BOOL) isAnswer;
- (BOOL) checkAnswer:(NSString*) anAnswer;
- (NSMutableArray*) getAnswerArrayWithTrueCount:(NSInteger) tc andFalseCount:(NSInteger) fc;
@property (nonatomic, copy) NSString *Question;
@property (nonatomic, assign) NSMutableArray *trueAnswers; //Fixme: use retain, or make readonly...
@property (nonatomic, assign) NSMutableArray *falseAnswers; // ...or dont use properties at all?
@end


//Remember to manage the supplied string....
