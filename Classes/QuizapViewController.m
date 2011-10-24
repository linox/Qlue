//
//  QuizapViewController.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// FIXME: BUG - PopTips implementation is bad, specifically when removing an old pop tip.


#import "QuizapViewController.h"
#import "QuizStore.h"


@implementation QuizapViewController

@synthesize highScore, hintLabel, QLabel, ChoiceButton1, ChoiceButton2, ChoiceButton3;
@synthesize currentPopTipViewTarget;

// Function to randomize objects in an array.
// Called from sortUsingFunction in NSMutableArray 
int randomSort(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1, 
	// arc4random doesnt need seeding (iOS developer tips - getting a random number).
    return (arc4random()%3 - 1);    
}


// Fixme: Rename method to ButtonDown
- (IBAction)showPopTipOnView:(id)sender {
	UIButton *btn = (UIButton *) sender;
	[btn setFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, 100,100)];

	
		NSString *message = [(UIButton*) sender currentTitle];
		
		popTipView = [[[CMPopTipView alloc] initWithMessage:message] autorelease];
		popTipView.delegate = self;

        popTipView.animation = 1; //Zoom
		
		if ([sender isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)sender;
			[popTipView presentPointingAtView:button inView:self.view animated:YES];
		}
		
		else {
			UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
			[popTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
		}

}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
	NSLog(@"Pop tip removed!");
}

- (void) reset {
	[[self navigationItem] setTitle:[NSString stringWithFormat:@"Fråga %i", BrainOO.pos+1]];// FIXME: String LEEK! autorelease?
	
	QAMultiChoiceQuestion *q;
	NSMutableArray *buttons;

	q = [BrainOO questionAtCurrentPosition];
	[q retain]; // DEBUG: Is this necessary? The controller outlives its Brain model? q is part of Brain.
	self.QLabel.text = [q Question]; // the question string...
	
	//Randomize answers
	buttons = [q getAnswerArrayWithTrueCount:1 andFalseCount:2];
	[buttons retain];
	NSLog(@"aaa size=%d", [buttons count]);
	[buttons sortUsingFunction:randomSort context:nil]; // randomize questions
	[[ChoiceButtons objectAtIndex: 0] setTitle:[buttons objectAtIndex:0] forState:UIControlStateNormal];
	[[ChoiceButtons objectAtIndex: 1] setTitle:[buttons objectAtIndex:1] forState:UIControlStateNormal];
	[[ChoiceButtons objectAtIndex: 2] setTitle:[buttons objectAtIndex:2] forState:UIControlStateNormal];
	[buttons release];
	[q release];
	
}

- (void) showHighScore {

	if(!self.highScore) {
		HighscoreViewController *hs = [[HighscoreViewController alloc]
									   initWithNibName:@"HighscoreViewController" bundle:[NSBundle mainBundle]];
		self.highScore = hs;
		[hs release];
		NSLog(@"hello from highscore");
	}
	
	[self.highScore refresh];
	[self.navigationController pushViewController:self.highScore animated:YES];
}

// This method gets fired on when a user stops pressing a button
// It will remove the popup that gets displayed when user holds the button down.
// It also checks to see if the button has been dragged into a container.
- (IBAction) ButtonPressed:(id) sender {
	// Remove the popup for the view
	if (popTipView != nil) {
		[popTipView dismissAnimated:YES];
		popTipView = nil; //FIXME: LEEEEK?
		
	}
	
	UIButton *btn = (UIButton *) sender;
	
	[self checkCollision:sender];
	
	NSLog(@"ButtonPressed:%@", [btn currentTitle]);

}

// Go to next question, we get called from UIBar "Next" button...
- (IBAction) NextButtonPressed:(id) sender {
	UIButton *btn;
	
	// Assume the first containerframe in Containers is the "Correct Answer" containerframe...
	// Look through all the objects added to it and check them with the answer...
	
	for (btn in [[Containers objectAtIndex:0] objects]) {
		NSLog(@"btn in containers = %@", btn.titleLabel.text);
		[BrainOO checkQuestion:btn.titleLabel.text];
	}
	
	[self nextQuestion];
}


- (void) nextQuestion {

	if ([BrainOO advancePosition]) {
		
		QuizapViewController *qavc = [[QuizapViewController alloc]
									   initWithNibName:@"QuizapViewController" bundle:[NSBundle mainBundle]];

		
		[self.navigationController pushViewController:qavc animated:YES];

	} else { 

		[self showHighScore];
	
		
	}		
	
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

- (void) draggedOut: (UIControl *) c withEvent: (UIEvent *) ev {
	c.center = [[[ev allTouches] anyObject] locationInView:nil];
}

- (void) checkAnyCollision {
	// Look through all Containers and ChoiceButtons to see if they overlap
}

// Check if sender overlaps any container
- (void) checkCollision:(UIView *) sender {
	ContainerFrame *cf;
	
	CGRect senderframe = CGRectMake(sender.frame.origin.x,
									sender.frame.origin.y,
									sender.frame.size.width,
									sender.frame.size.height);
	
	// If the view is not part of any container(see below) put it on the main view...
	//UIView *target = self.view;
	// remove from superview... because we are going to add it again below
	//[sender removeFromSuperview]; 
	// set default size so if we drop our view outside a container it will have correct size again...

	
	for (cf in Containers) { // FIXME: Should cf be retained?
		
		// Remove it from any eventual container... it will get added again below...
		// We dont care if the object isnt part of the container since that wouldnt do anything
		[cf removeObject:sender];
		
		// Check to see if the object is dropped by user over a containerframe in which case we add it...
		if([cf checkBounds:senderframe]) {
			// frames overlap!
			NSLog(@"Frames overlap!");
			//target = cf;
			//[cf addSubview:sender]; // ...and add to frame instead...
			NSLog(@"containerType = %d", cf.containerType); 
			[cf addObject:sender];
			if (cf.containerType == 1) {
				//The object is added to the "Question hint container"
				if ([BrainOO isAnswer:((UIButton*) sender).titleLabel.text ]){
					self.hintLabel.text = @"Yes!";
				} else {
					self.hintLabel.text = @"No!";
				}
			}
		} 
	}
	
	// add to target
	//[target addSubview:sender];
	
}

// Detect back button press in navigation bar
// Solution from StackOverflow William Jockusch, thanks.
- (void) viewWillDisappear:(BOOL)animated {
	if( [self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
		
		[BrainOO decreasePosition];
		NSLog(@"Back button hit!");
		
		
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// Add the next button on the nav bar.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" 
																			  style:UIBarButtonItemStylePlain 
																			 target:self 
																			 action:@selector(NextButtonPressed:)]autorelease];

	

	// Create the main view
	self.wantsFullScreenLayout = YES;
	UIView *screen = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	self.view = screen;
	
	screen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"classroom2.jpg"]];
	
	self.QLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 32)];
	QLabel.textColor = [UIColor whiteColor];
	QLabel.backgroundColor = [UIColor blackColor];
	[screen addSubview:QLabel];
	
	self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 200, 32)];
//	hintLabel.textColor = [UIColor whiteColor];
//	hintLabel.backgroundColor = [UIColor blackColor];
	hintLabel.text = @"Ask the nerd ->";
	[screen addSubview:hintLabel];
	
	// FIXME: Testing Container, create Blackboard-container
	ContainerFrame *cf = [[ContainerFrame alloc] initWithFrame:CGRectMake(20, 40, 280, 64)];
	[self.view addSubview:cf];
	cf.containerType = 0; // 0 means its the "Answer container"...
	
	//Create the containers array
	Containers = [[NSMutableArray alloc] initWithObjects:cf, nil];
	[cf release];
	
	// Create another container, This could be the "class nerd" container
	// I.e dropping an answer in this container shows yes or no dependeing on answer is correct or not.
	cf = [[ContainerFrame alloc] initWithFrame:CGRectMake(260, 240, 64, 64)];
	cf.containerType = 1; // This could be the "question hint" container...
	[self.view addSubview:cf];
	// add to containers
	[Containers addObject:cf];
	[cf release];


	// Make the buttons array so we can keep track of our buttons later...
	ChoiceButtons = [[NSMutableArray alloc] init];

	// Make 3 buttons...
	for (int i=0; i < 3; i++) {
		// Make the button and set it all up
		UIButton *b = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];

		// Button press down event
		// Could be a start of a drag event, but also just a single click.
		[b addTarget:self 
			  action:@selector(showPopTipOnView:)
				forControlEvents:UIControlEventTouchDown];

		// When user stop holding down a button 
		// Could be after a finished drag n drop, but also just a single press.
		[b addTarget:self
			  action:@selector(ButtonPressed:)
	forControlEvents:UIControlEventTouchUpInside];
		
		// Drag n drop
		[b addTarget:self action:@selector(draggedOut:withEvent: ) 
		 forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
		
		NSString *str = [NSString stringWithFormat:@"button%i.jpg",i+1];
		[b setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
		[ChoiceButtons addObject:b];

		[b setFrame:CGRectMake(i*100, 300, 100, 100)];
		[self.view addSubview:b];

		[b release];
	}

 
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	QuizStore *qs = [QuizStore defaultStore];
	BrainOO = [[qs allQuizes] objectAtIndex:qs.currentQuizIndex];
	NSLog(@"View did load!!");

	[self reset];
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


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
	[QLabel release];
	[Containers release]; 
	[ChoiceButtons release];
	[BrainOO release];
    [super dealloc];
}

@end
