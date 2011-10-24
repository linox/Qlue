//
//  QuizapEditQuizViewController.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizapEditQuizViewController.h"
#import "QuizStore.h"
#import "QuizBrainOO.h"

@implementation QuizapEditQuizViewController

@synthesize textBox, contents;

- (void)doneEditing {
	QuizStore *qs = [QuizStore defaultStore];
	int idx = qs.currentQuizIndex;
	
	// If we arrived here directly from ItemsViewController theres no current quiz selected...
	NSString *oldID;
	if (idx < 0) {
		oldID = nil;
	// We arrived here from selecting edit in a Quiz (QuizSelectedViewController)...
	} else {
		oldID = [[[qs allQuizes] objectAtIndex:qs.currentQuizIndex] ID];
	}

	
	
	QuizBrainOO *b = [qs createQuizFromString:[textBox text] withID:oldID];
	NSLog(@"popping with json:%@", [textBox text]);

	//b.ID = oldID;
	[qs updateQuiz:b];
	
	//QuizBrainOO *b = [[qs allQuizes] objectAtIndex:qs.currentQuizIndex];
	//b.json = [textBox text];
	
	[self.navigationController popViewControllerAnimated:YES];
	
}


//- (void)textViewDidEndEditing:(UITextView *)textView {
//	[self doneEditing];
//}

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
	[textBox setFont:[UIFont fontWithName:@"ArialMT" size:10]];
	
	// Create a new bar button item that will send
	// addNewPossession: to ItemsViewController
	UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
							initWithBarButtonSystemItem:UIBarButtonSystemItemDone
							target:self
							action:@selector(doneEditing)];
	// Set this bar button item as the right item in the navigationItem
	[[self navigationItem] setRightBarButtonItem:bbi];
	// The navigationItem retains its buttons, so bbi can be released
	[bbi release];
	
	if(contents != nil) {
		textBox.text = contents;
	}
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
