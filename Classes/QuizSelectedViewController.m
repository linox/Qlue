//
//  QuizSelectedViewController.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizSelectedViewController.h"
#import "QuizapEditQuizViewController.h"
#import "QuizapView3Controller.h"
#import "QuizStore.h"

@implementation QuizSelectedViewController

- (IBAction) playButtonPressed:(id) sender{
	QuizStore *qs = [QuizStore defaultStore];
	
	QuizapView3Controller *detailViewController =
	[[[QuizapView3Controller alloc] init] autorelease];
	

	detailViewController.BrainOO = [[qs allQuizes] objectAtIndex:qs.currentQuizIndex];
	[detailViewController initsetup];
	[detailViewController reset];
	
	
	// Push it onto the top of the navigation controller's stack
	[[self navigationController] pushViewController:detailViewController
                                           animated:YES];
}

- (IBAction) editButtonPressed:(id) sender{

	QuizStore *qs = [QuizStore defaultStore];

	QuizapEditQuizViewController *qe = [[QuizapEditQuizViewController alloc] init];
	
	qe.contents = [[[qs allQuizes] objectAtIndex:qs.currentQuizIndex] json];
	
	[[self navigationController] pushViewController:qe
                                           animated:YES];
	
	[qe autorelease];
	

}

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
