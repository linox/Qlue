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
#import "ContainerFrame.h"
#import "../CMPopTipView/CMPopTipView.h"

@interface QuizapViewController : UIViewController  <CMPopTipViewDelegate> {
	HighscoreViewController *highScore;

	QuizBrainOO *BrainOO;

	IBOutlet UILabel *QLabel;
	UILabel *hintLabel;
	
	NSMutableArray *ChoiceButtons; // FIXME: come up with a better name...
	
	NSMutableArray *Containers; // Array of containers present in the view

	CMPopTipView *popTipView;
}



- (void) nextQuestion;
- (void) showHighScore;
- (void) reset; // FIXME: rename to something better, like setup perhaps...
- (void) checkAnyCollision; // checks to see if view objects overlap...
- (void) checkCollision:(id) sender;

- (IBAction) showPopTipOnView:(id)sender; // FIXME: Rename to ButtonDown or something
- (IBAction) ButtonPressed:(id) sender;
- (IBAction) NextButtonPressed:(id) sender;

@property (nonatomic,retain) HighscoreViewController *highScore;
@property (nonatomic,retain) IBOutlet UILabel *QLabel, *hintLabel;
@property (nonatomic,retain) IBOutlet UIButton *ChoiceButton1, *ChoiceButton2, *ChoiceButton3;
@property (nonatomic,retain) CMPopTipView *currentPopTipViewTarget;
@end

