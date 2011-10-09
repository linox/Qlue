//
//  QuizapViewController.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizBrainOO.h"
#import "QAMultiChoiceQuestion.h"
#import "HighscoreViewController.h"

@interface QuizapViewController : UIViewController {
	HighscoreViewController *highScore;
	//QuizBrain *Brain;
	QuizBrainOO *BrainOO;

	IBOutlet UILabel *QLabel;
	IBOutlet UIButton *ChoiceButton1;
	IBOutlet UIButton *ChoiceButton2;
	IBOutlet UIButton *ChoiceButton3;
	
	//NSMutableArray *buttons;
	
	//NSInteger pos;
}



- (void) nextQuestion;
- (void) showHighScore;
- (void) reset; // FIXME: rename to something better, like setup perhaps...

- (IBAction) ButtonPressed:(id) sender;
@property (nonatomic,retain) HighscoreViewController *highScore;
@property (nonatomic,retain) IBOutlet UILabel *QLabel;
@property (nonatomic,retain) IBOutlet UIButton *ChoiceButton1, *ChoiceButton2, *ChoiceButton3;
@end

