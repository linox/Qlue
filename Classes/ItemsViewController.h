//
//  ItemsViewController.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizapView2Controller.h"


@interface ItemsViewController : UITableViewController <UIAlertViewDelegate> 
{
		IBOutlet UIView *headerView;
}
	
- (UIView *)headerView;
- (IBAction)addNewQuiz:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;


@end
