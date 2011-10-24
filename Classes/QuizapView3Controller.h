//
//  QuizapView3Controller.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizBrainOO.h"
#import "QAMultiChoiceQuestion.h"
#import "HighscoreViewController.h"
#import "ContainerFrame.h"
#import "../CMPopTipView/CMPopTipView.h"

@interface QuizapView3Controller : UIViewController  <CMPopTipViewDelegate> {
	HighscoreViewController *highScore;
	
	QuizBrainOO *BrainOO;
	
	IBOutlet UILabel *QLabel;
	UILabel *hintLabel;
	
	NSMutableArray *ChoiceButtons; // FIXME: come up with a better name...
	NSMutableArray *ChoiceLabels;
	
	NSMutableArray *Containers; // Array of containers present in the view
	
	CMPopTipView *popTipView;
	UIButton *currentView;//When user press a button we store a reference to that button in here so that longPressureGesture can know which button fired it...
	
	CGPoint touchStart;
	QuizapView3Controller *lastViewController;
}



- (void) nextQuestion;
- (void) showHighScore;
- (void) initsetup;
- (void) reset; // FIXME: rename to something better, like setup perhaps...
- (void) checkAnyCollision; // checks to see if view objects overlap...
- (void) checkCollision:(id) sender;
- (void) highlightButton:(UIButton *)b;

- (void)swipeUp:(UISwipeGestureRecognizer *)recognizer;
- (IBAction) PressDownButton:(id)sender;
- (IBAction) showPopTipOnView:(id)sender; // FIXME: Rename to ButtonDown or something
- (void) removePopTip;
- (IBAction) ButtonPressed:(id) sender;
- (IBAction) NextButtonPressed:(id) sender;
@property (nonatomic,assign) CGPoint touchStart;
@property (nonatomic,retain) HighscoreViewController *highScore;
@property (nonatomic,retain) IBOutlet UILabel *QLabel, *hintLabel;
@property (nonatomic,retain) IBOutlet UIButton *ChoiceButton1, *ChoiceButton2, *ChoiceButton3;
@property (nonatomic,retain) CMPopTipView *currentPopTipViewTarget;
@property (nonatomic,retain) QuizBrainOO *BrainOO;
@end
