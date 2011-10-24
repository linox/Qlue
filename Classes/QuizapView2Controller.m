//
//  QuizapView2Controller.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// FIXME: BUG - PopTips implementation is bad, specifically when removing an old pop tip.


#import "QuizapView2Controller.h"
//#import "QuizapAppDelegate.h"
#import "QuizStore.h"

@implementation QuizapView2Controller

@synthesize highScore, hintLabel, QLabel, ChoiceButton1, ChoiceButton2, ChoiceButton3;
@synthesize currentPopTipViewTarget;
@synthesize touchStart;
@synthesize BrainOO;

// Function to randomize objects in an array.
// Called from sortUsingFunction in NSMutableArray 
int QArandomSort(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1, 
	// arc4random doesnt need seeding (iOS developer tips - getting a random number).
    return (arc4random()%3 - 1);    
}


// Fixme: Rename method to ButtonDown
- (IBAction)showPopTipOnView:(id)sender {
	//UIButton *btn = (UIButton *) sender;
	//[btn setFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, 100,100)];

	
		NSString *message = [(UIButton*) sender currentTitle];
		
		popTipView = [[[CMPopTipView alloc] initWithMessage:message] autorelease];
		popTipView.delegate = self;
	    popTipView.backgroundColor = [UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1];
	popTipView.textColor = [UIColor blackColor];

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

- (IBAction)PressDownButton:(id)sender{
	
	currentView = (UIButton *) sender;
	
	// This shows the popup when clicking on button..
	[self showPopTipOnView:sender];
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
	
	// Randomize answers
	// If the returned array dont have enough wrong or right answers it returns a smaller array than asked for!!
	// FIXME: Remember that this function gets called in initsetup too, so fix it!!
	buttons = [q getAnswerArrayWithTrueCount:1 andFalseCount:4]; //FIXME: You should check the size of the returned array
	[buttons retain];
	NSLog(@"aaa size=%d", [buttons count]);
	[buttons sortUsingFunction:QArandomSort context:nil]; // randomize questions
	
	for (int i=0; i < [buttons count]; i++) {
		[[ChoiceButtons objectAtIndex: i] setTitle:[buttons objectAtIndex:i] forState:UIControlStateNormal];
	}

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

//This lets the button be pressed down
- (void)highlightButton:(UIButton *)b { 
    [b setHighlighted:YES];
}

- (void) removePopTip
{
	// Remove the popup for the view
	if (popTipView != nil) {
		[popTipView dismissAnimated:YES];
		popTipView = nil; //FIXME: LEEEEK?
		
	}
}

// This method gets fired on when a user stops pressing a button
// It will remove the popup that gets displayed when user holds the button down.
// It also checks to see if the button has been dragged into a container.
- (IBAction) ButtonPressed:(id) sender {
	UIButton *btn = (UIButton *) sender;
	//Keep button in pressed state...
	//[self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];

	if (btn.selected) {
		[btn setSelected:NO];
	} else {
		//[btn setSelected:YES];
		
	}
	

	[self removePopTip];

	
	[self checkCollision:sender];
	
	NSLog(@"ButtonPressed:%@", [btn currentTitle]);

}

// Go to next question, we get called from UIBar "Next" button...
- (IBAction) NextButtonPressed:(id) sender {
	UIButton *btn;
	[BrainOO resetScoreAtCurrentPos];

	for (btn in ChoiceButtons) {
		NSLog(@"btn in containers = %@", btn.titleLabel.text);

		if (btn.selected) {
			[BrainOO checkQuestion:btn.titleLabel.text withCondition:YES];
		} else {
			//[BrainOO checkQuestion:btn.titleLabel.text withCondition:NO];
		}

		
	}
	
	[self nextQuestion];
}


- (void) nextQuestion {
	// If we arrived at this view by pressing back button, go to next view that is stored in LastviewContr.... 

	if ([BrainOO advancePosition]) {
		

		if (lastViewController != nil) {
			[self.navigationController pushViewController:lastViewController animated:YES];
			NSLog(@"Using our stored lastview!");
		} else {		
		
			QuizapView2Controller *qavc = [[QuizapView2Controller alloc] init];
			qavc.BrainOO = self.BrainOO;
			[qavc initsetup];
			[qavc reset];
		
			[self.navigationController pushViewController:qavc animated:YES];
			lastViewController = [qavc retain];
		}
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
	//UIButton *btn = (UIButton *) c;
	//c.center = [[[ev allTouches] anyObject] locationInView:nil];

}

- (void)swipeUp:(UISwipeGestureRecognizer *)recognizer 
{ 
	CGPoint point = [recognizer locationInView:[self view]];
	NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);

	[self removePopTip];
	
	[currentView setSelected:YES];
		
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if(UIGestureRecognizerStateBegan == gesture.state) {
        // Do initial work here
		NSLog(@"Touch down!");
		//[self showPopTipOnView:currentView];
		 
		 }
	
    if(UIGestureRecognizerStateChanged == gesture.state) {
        // Do repeated work here (repeats continuously) while finger is down
    }
	
    if(UIGestureRecognizerStateEnded == gesture.state) {
        // Do end work here when finger is lifted
    }
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

//			if (cf.containerType == 1) {
//				//The object is added to the "Question hint container"
//				if ([BrainOO isAnswer:((UIButton*) sender).titleLabel.text ]){
//					self.hintLabel.text = @"Yes!";
//				} else {
//					self.hintLabel.text = @"No!";
//				}
//			}
		} 
	}
	
	// add to target
	//[target addSubview:sender];
	
}

// Detect back button press in navigation bar
// Solution from StackOverflow William Jockusch, thanks.
- (void) viewWillDisappear:(BOOL)animated {
	if( [self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
		
		//lastViewController = self; // Store our viewcontroller so we can come back here
		//[lastViewController retain];
		[BrainOO decreasePosition];
		NSLog(@"Back button hit!");
		
		
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) initsetup {
	// Add the next button on the nav bar.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" 
																			  style:UIBarButtonItemStylePlain 
																			 target:self 
																			 action:@selector(NextButtonPressed:)]autorelease];


	// Create the main view
	self.wantsFullScreenLayout = YES;
	UIView *screen = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	self.view = screen;
	
	screen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"classroom3.png"]];
	
	self.QLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 10, 280, 150)];
	QLabel.textColor = [UIColor whiteColor];
	QLabel.backgroundColor = [UIColor clearColor];
	QLabel.lineBreakMode = UILineBreakModeWordWrap;
	QLabel.numberOfLines = 0;
	[screen addSubview:QLabel];
	
//	self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 200, 32)];
//	hintLabel.textColor = [UIColor whiteColor];
//	hintLabel.backgroundColor = [UIColor blackColor];
//	hintLabel.text = @"Ask the nerd ->";
//	[screen addSubview:hintLabel];
//	
//	// FIXME: Testing Container, create Blackboard-container
//	ContainerFrame *cf = [[ContainerFrame alloc] initWithFrame:CGRectMake(20, 40, 280, 64)];
//	[self.view addSubview:cf];
//	cf.containerType = 0; // 0 means its the "Answer container"...
//	
//	//Create the containers array
//	Containers = [[NSMutableArray alloc] initWithObjects:cf, nil];
//	[cf release];
//	
//	// Create another container, This could be the "class nerd" container
//	// I.e dropping an answer in this container shows yes or no dependeing on answer is correct or not.
//	cf = [[ContainerFrame alloc] initWithFrame:CGRectMake(260, 240, 64, 64)];
//	cf.containerType = 1; // This could be the "question hint" container...
//	[self.view addSubview:cf];
//	// add to containers
//	[Containers addObject:cf];
//	[cf release];


	// Make the buttons array so we can keep track of our buttons later...
	ChoiceButtons = [[NSMutableArray alloc] init];
	
	//Create teacher...
	UIButton *t = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[t setTitle:@"Hi! Im the teacher..." forState:UIControlStateNormal];
	NSString *str = @"teacher.png";
	[t setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
	[t setFrame:CGRectMake(100, 140, 116, 95)];
	[self.view addSubview:t];
	
	[t addTarget:self 
		  action:@selector(PressDownButton:)
forControlEvents:UIControlEventTouchDown];
	
	// When user stop holding down a button 
	// Could be after a finished drag n drop, but also just a single press.
	[t addTarget:self
		  action:@selector(ButtonPressed:)
forControlEvents:UIControlEventTouchUpInside];
	
	[t release];
	QAMultiChoiceQuestion *q = [BrainOO questionAtCurrentPosition];
	NSArray *questionarray = [q getAnswerArrayWithTrueCount:1 andFalseCount:4];
	// Make 3 buttons...
	for (int i=0; i < [questionarray count]; i++) {
		// Make the button and set it all up
		UIButton *b = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		//b. = [UIColor colorWithRed:(203.0/255.0) green:(42.0/255.0) blue:(20.0/255.0) alpha:0.5];

		// Button press down event
		// Could be a start of a drag event, but also just a single click.
		[b addTarget:self 
			  action:@selector(PressDownButton:)
				forControlEvents:UIControlEventTouchDown];

		// When user stop holding down a button 
		// Could be after a finished drag n drop, but also just a single press.
		[b addTarget:self
			  action:@selector(ButtonPressed:)
				forControlEvents:UIControlEventTouchUpInside];
		
		// Drag n drop
		//[b addTarget:self action:@selector(draggedOut:withEvent:) 
		// forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
		
		// Create long touch action recognizer
//		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//												   initWithTarget:self 
//												   action:@selector(handleLongPress:)];
//		longPress.minimumPressDuration = 0.5;		
//		[b addGestureRecognizer:longPress];
//		[longPress release];
		
		
		UISwipeGestureRecognizer *swipeGesture = 
		[[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)] autorelease];
		[swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
		[b addGestureRecognizer:swipeGesture];		
		
		NSString *str = @"studentfull1.png";
		[b setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
		str = @"studentfull2.png";
		[b setImage:[UIImage imageNamed:str] forState:UIControlStateSelected];
		str = @"studentfull3.png";
		[b setImage:[UIImage imageNamed:str] forState:UIControlStateHighlighted];

		
		[ChoiceButtons addObject:b];
		
		

		[b setFrame:CGRectMake(2+i*54, 320, 50, 82)];
		[self.view addSubview:b];

		[b release];
	}



 
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//QuizapAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//BrainOO = [appDelegate.GlobalBrainOO retain];
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
