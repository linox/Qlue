//
//  HighscoreViewController.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HighscoreViewController : UIViewController {
	IBOutlet UILabel *correctLabel;
	IBOutlet UILabel *wrongLabel;

}

- (void) refresh;

- (IBAction) clickResetScore:(id) sender;
- (IBAction) saveScore:(id) sender;

//Fixme: should property be assign or retain?
@property (nonatomic,retain) IBOutlet UILabel *correctLabel;
@property (nonatomic,retain) IBOutlet UILabel *wrongLabel;

@end
