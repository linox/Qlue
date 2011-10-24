//
//  QuizStore.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizBrainOO.h"
#import "QAMultiChoiceQuestion.h"


@interface QuizStore : NSObject {

	NSMutableDictionary *QuizDB;
	//NSMutableArray *allQuizes;
	NSInteger currentQuizIndex;
	
}

+ (QuizStore *)defaultStore;

- (void)removeQuiz:(QuizBrainOO *)b;
- (void)updateQuiz:(QuizBrainOO *)b;
- (void) saveCurrentQuiz;
- (NSArray *) allQuizes;
- (QuizBrainOO *) quizWithKey:(NSString *) key;
-(void) writeToDocumentsDirectory:(NSString *)fileName withContentsOfString:(NSString *) contents;
- (QuizBrainOO *) loadQuizFromFile:(NSString *) filePath;
- (void) createQuiz;
- (QuizBrainOO *) createQuizFromString:(NSString *)str withID:(NSString *) ID;

@property (nonatomic, assign) NSInteger currentQuizIndex;
@end