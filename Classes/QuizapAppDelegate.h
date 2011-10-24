//
//  QuizapAppDelegate.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "QuizBrainOO.h"
#import "QAMultiChoiceQuestion.h"
#import <UIKit/UIKit.h>

@class QuizapViewController;

@interface QuizapAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    QuizapViewController *viewController;
	UINavigationController *navigationController;

//	QuizBrainOO *GlobalBrainOO;
	
	
}
-(void) resetGame;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet QuizapViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
//@property (nonatomic, retain) QuizBrainOO *GlobalBrainOO;

//- (IBAction) NextButtonPressed:(id) sender;

@end

