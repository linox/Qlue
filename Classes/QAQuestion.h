//
//  QAQuestion.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QAQuestion : NSObject {
	
	NSString *Question;
	NSString *Answer;
	
}


- (id) initWithQuestion:(NSString *) q andAnswer:(NSString *) a;
						
- (BOOL) isAnswer:(NSString *) anAnswer;

@property (nonatomic, copy) NSString *Question;
@property (nonatomic, copy) NSString *Answer;

@end
