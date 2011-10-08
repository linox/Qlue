//
//  QuizBrainOO.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizBrain.h"
#import "QAMultiChoiceQuestion.h"


@interface QuizBrainOO : QuizBrain {

}

//aArray = array with QAMultiChoiceQuestions
- (id) initWithQuestions:(NSMutableArray *) qArray;

- (QAMultiChoiceQuestion *) questionAtIndex: (NSInteger) index;
- (QAMultiChoiceQuestion *) questionAtCurrentPosition;
- (void) checkQuestion:(NSString *) aStr;

@end
