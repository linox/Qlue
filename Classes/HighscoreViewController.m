//
//  HighscoreViewController.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "QuizapAppDelegate.h"
#import "HighscoreViewController.h"
#import "QuizStore.h"

@implementation HighscoreViewController
@synthesize correctLabel,wrongLabel;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self refresh];



}

- (void) refresh {
	QuizStore *qs = [QuizStore defaultStore];
	QuizBrainOO *b = [[qs allQuizes] objectAtIndex:qs.currentQuizIndex];
	
	int theScore = [b.getScore intValue];

	if (theScore > 0) {
		self.correctLabel.text = [NSString stringWithFormat:@"Correct answers: %d", 
							  theScore];
	} else {
		self.correctLabel.text = @"No correct answers!";
	}

	
//	self.correctLabel.text = [NSString stringWithFormat:@"Antal korrekta svar: %d", 
//							  appDelegate.GlobalBrainOO.correctAnswers];
//	
//	self.wrongLabel.text = [NSString stringWithFormat:@"Antal felaktiga svar: %d", 
//							appDelegate.GlobalBrainOO.wrongAnswers];
}


- (IBAction) clickResetScore:(id) sender {
	QuizStore *qs = [QuizStore defaultStore];
	
	// Reset the brain...
	[[[qs allQuizes] objectAtIndex:qs.currentQuizIndex] reset];

	NSLog(@"Hello from clickReset!");
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction) saveScore:(id) sender {
	

	QuizStore *qs = [QuizStore defaultStore]; 
		
	QuizBrainOO *b = [[qs allQuizes] objectAtIndex:qs.currentQuizIndex];
	
	b.savedScore = [b.getScore intValue];
	
	[qs saveCurrentQuiz];
	
	//[b reset]; // this does not reset the savedScore...

	//[self.navigationController popToRootViewControllerAnimated:YES];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
