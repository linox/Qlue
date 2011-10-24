//
//  QuizapEditQuizViewController.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuizapEditQuizViewController : UIViewController <UITextViewDelegate> {
	IBOutlet UITextView *textBox;
	NSString *contents;
}

@property (nonatomic, retain) IBOutlet UITextView *textBox;
@property (nonatomic, retain) NSString *contents;

@end
