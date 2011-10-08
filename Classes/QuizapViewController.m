//
//  QuizapViewController.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizapViewController.h"
#import "QuizapAppDelegate.h"

@implementation QuizapViewController

@synthesize highScore, QLabel, ChoiceButton1, ChoiceButton2, ChoiceButton3;


// Function to randomize objects in an array.
// Called from sortUsingFunction in NSMutableArray 
int randomSort(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1, 
	// arc4random doesnt need seeding (iOS developer tips - getting a random number).
	NSLog (@"random=%i", arc4random()%3 - 1);
    return (arc4random()%3 - 1);    
}

- (void) reset {

	
	[self nextQuestion];
	
//	QAMultiChoiceQuestion *q;
//	NSMutableArray *buttons;
	//q = [BrainOO questionAtIndex:0];
//	[q retain];
//	QLabel.text = [q Question]; // the question string...
//	
//	//Randomize answers
//	buttons = [q getAnswerArrayWithTrueCount:1 andFalseCount:2];
//	[buttons retain];
//	NSLog(@"aaa size=%d", [buttons count]);
//	[buttons sortUsingFunction:randomSort context:nil]; // randomize questions
//	[ChoiceButton1 setTitle:[buttons objectAtIndex:0] forState:UIControlStateNormal];
//	[ChoiceButton2 setTitle:[buttons objectAtIndex:1] forState:UIControlStateNormal];
//	[ChoiceButton3 setTitle:[buttons objectAtIndex:2] forState:UIControlStateNormal];
//	[buttons release];
//	[q release];
	
	
}

- (void) showHighScore {
	//Fixme: LEEEEEEK!!
	//if(self.highScore == nil) {
		HighscoreViewController *hs = [[HighscoreViewController alloc]
									   initWithNibName:@"HighscoreViewController" bundle:[NSBundle mainBundle]];
		self.highScore = hs;
		[hs release];
		NSLog(@"hello from highscore");
	//}
	
	[self.highScore refresh];
	[self.navigationController pushViewController:self.highScore animated:YES];
}

- (IBAction) ButtonPressed:(id) sender {
	UIButton *btn = (UIButton *) sender;
	
	NSLog(@"ButtonPressed:%@", [btn currentTitle]);
	
	[BrainOO checkQuestion:btn.titleLabel.text];
	
	[self nextQuestion];
}


- (void) nextQuestion {
	QAMultiChoiceQuestion *q;
	NSMutableArray *buttons;
	

	if ([BrainOO advancePosition]) {
	
		q = [BrainOO questionAtCurrentPosition];
		[q retain];
		self.QLabel.text = [q Question]; // the question string...
		
		//Randomize answers
		buttons = [q getAnswerArrayWithTrueCount:1 andFalseCount:2];
		[buttons retain];
		NSLog(@"aaa size=%d", [buttons count]);
		[buttons sortUsingFunction:randomSort context:nil]; // randomize questions
		[self.ChoiceButton1 setTitle:[buttons objectAtIndex:0] forState:UIControlStateNormal];
		[self.ChoiceButton2 setTitle:[buttons objectAtIndex:1] forState:UIControlStateNormal];
		[self.ChoiceButton3 setTitle:[buttons objectAtIndex:2] forState:UIControlStateNormal];
		[buttons release];
		[q release];
		

	} else { 

		[self showHighScore];
	
		
	} // FIXME: Do something when all questions have been answered...
		


	NSLog(@"Correct=%d, Incorrect=%d", BrainOO.correctAnswers, BrainOO.wrongAnswers);
	
				   
	
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
    }
	NSLog(@"Hello from initWithNib");
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//NSMutableArray *qa = [NSArray arrayWithObjects:@"Första frågan?", @"Andra frågan?", @"Tredje frågan?", nil];
	//NSMutableArray *aa = [NSArray arrayWithObjects:@"Första svaret", @"Andra svaret", @"Tredje svaret", nil];
	
	//Brain = [[QuizBrain alloc] initWithQuestions: qa
	//								  andAnswers: aa];
	
	QuizapAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	BrainOO = [appDelegate.GlobalBrainOO retain];
	
	[BrainOO reset];
	
//	NSMutableArray *buttons = [mq getAnswerArrayWithTrueCount:1 andFalseCount:2];
//	[buttons retain];
//	NSLog(@"aaa size=%d", [buttons count]);
//	[buttons sortUsingFunction:randomSort context:nil]; // randomize questions
//	[ChoiceButton1 setTitle:[buttons objectAtIndex:0] forState:UIControlStateNormal];
//	[ChoiceButton2 setTitle:[buttons objectAtIndex:1] forState:UIControlStateNormal];
//	[ChoiceButton3 setTitle:[buttons objectAtIndex:2] forState:UIControlStateNormal];
//	[buttons release];
//	
	
	

	[self reset];

}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[BrainOO release];
    [super dealloc];
}

@end
