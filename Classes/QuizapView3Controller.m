//
//  QuizapView3Controller.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// FIXME: BUG - PopTips implementation is bad, specifically when removing an old pop tip.


#import "QuizapView3Controller.h"
//#import "QuizapAppDelegate.h"
#import "QuizStore.h"

@implementation QuizapView3Controller

@synthesize highScore, hintLabel, QLabel, ChoiceButton1, ChoiceButton2, ChoiceButton3;
@synthesize currentPopTipViewTarget;
@synthesize touchStart;
@synthesize BrainOO;

// Function to randomize objects in an array.
// Called from sortUsingFunction in NSMutableArray 
int QArandomSort3(id obj1, id obj2, void *context ) {
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
	//[self showPopTipOnView:sender];
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

	NSString *ourText = [q Question]; // the question string...

	self.QLabel.text = 	ourText;
	
	UIFont *font = [UIFont fontWithName:@"Marker Felt" size:28];
	
	
	int j;
	
	for(j = 28; j > 2; j=j-2)
	{
		// Set the new font size.
		font = [font fontWithSize:j];
		// You can log the size you're trying: NSLog(@"Trying size: %u", i);
		NSLog(@"Trying size: %u, ourtext=%@", j, ourText);
		/* This step is important: We make a constraint box 
		 using only the fixed WIDTH of the UILabel. The height will
		 be checked later. */ 
		CGSize constraintSize = CGSizeMake(240.0f, MAXFLOAT);
		
		// This step checks how tall the label would be with the desired font.
		CGSize labelSize = [ourText sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		/* Here is where you use the height requirement!
		 Set the value in the if statement to the height of your UILabel
		 If the label fits into your required height, it will break the loop
		 and use that font size. */
		if(labelSize.height <= 150.0f) {
			break;
		}
	}
	// You can see what size the function is using by outputting: NSLog(@"Best size is: %u", i);
	
	// Set the UILabel's font to the newly adjusted font.
	[self.QLabel setFont:font];
	
	
	
	
	// Randomize answers
	// If the returned array dont have enough wrong or right answers it returns a smaller array than asked for!!
	// FIXME: Remember that this function gets called in initsetup too, so fix it!!
	buttons = [q getAnswerArrayWithTrueCount:1 andFalseCount:2]; //FIXME: You should check the size of the returned array
	[buttons retain];
	NSLog(@"aaa size=%d", [buttons count]);
	[buttons sortUsingFunction:QArandomSort3 context:nil]; // randomize questions
	
	for (int i=0; i < [buttons count]; i++) {
		[[ChoiceButtons objectAtIndex: i] setTitle:[buttons objectAtIndex:i] forState:UIControlStateNormal];
		//[[ChoiceLabels objectAtIndex:i] setText:[buttons objectAtIndex:i]];		
	
		//
		// Resize button labels to fit inside buttons with maximum possible font size...
		// See:http://www.11pixel.com/blog/28/resize-multi-line-text-to-fit-uilabel-on-iphone/
		NSString *ourText = [buttons objectAtIndex:i];
	
		/* This is where we define the ideal font that the Label wants to use.
		 Use the font you want to use and the largest font size you want to use. */
		UIFont *font = [UIFont fontWithName:@"Marker Felt" size:28];
	

		/* Time to calculate the needed font size.
		 This for loop starts at the largest font size, and decreases by two point sizes (i=i-2)
		 Until it either hits a size that will fit or hits the minimum size we want to allow (i > 10) */
		for(j = 28; j > 2; j=j-2)
		{
			// Set the new font size.
			font = [font fontWithSize:j];
			// You can log the size you're trying: NSLog(@"Trying size: %u", i);
			NSLog(@"Trying size: %u, ourtext=%@", j, ourText);
			/* This step is important: We make a constraint box 
			 using only the fixed WIDTH of the UILabel. The height will
			 be checked later. */ 
			CGSize constraintSize = CGSizeMake(240.0f, MAXFLOAT);
		
			// This step checks how tall the label would be with the desired font.
			CGSize labelSize = [ourText sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
			/* Here is where you use the height requirement!
			 Set the value in the if statement to the height of your UILabel
			 If the label fits into your required height, it will break the loop
			 and use that font size. */
			if(labelSize.height <= 64.0f) {
				break;
			}
		}
		// You can see what size the function is using by outputting: NSLog(@"Best size is: %u", i);
	
		// Set the UILabel's font to the newly adjusted font.
		[[ChoiceButtons objectAtIndex:i] setFont:font];
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
		[btn setSelected:YES];
		
	}
	
	
	//[self removePopTip];
	
	
	//[self checkCollision:sender];
	
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
			
			QuizapView3Controller *qavc = [[QuizapView3Controller alloc] init];
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
	
	//[self removePopTip];
	
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
	
	//screen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"classroom3.png"]];
	screen.backgroundColor = [UIColor clearColor];
	
	self.QLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 10, 280, 150)];
	QLabel.textColor = [UIColor whiteColor];
	QLabel.backgroundColor = [UIColor clearColor];
	QLabel.lineBreakMode = UILineBreakModeWordWrap;
	QLabel.numberOfLines = 0;
	
	UIFont *displayFont = [UIFont fontWithName:@"Marker Felt" size:24];
	QLabel.font = displayFont;
	
	[screen addSubview:QLabel];
	
	// Make the buttons array so we can keep track of our buttons later...
	ChoiceButtons = [[NSMutableArray alloc] init];
	ChoiceLabels = [[NSMutableArray alloc] init];
	
	//Create teacher...
//	UIButton *t = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//	[t setTitle:@"Hi! Im the teacher..." forState:UIControlStateNormal];
//	NSString *str = @"teacher.png";
//	[t setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
//	[t setFrame:CGRectMake(100, 140, 116, 95)];
//	[self.view addSubview:t];
	
//	[t addTarget:self 
//		  action:@selector(PressDownButton:)
//forControlEvents:UIControlEventTouchDown];
//	
//	// When user stop holding down a button 
//	// Could be after a finished drag n drop, but also just a single press.
//	[t addTarget:self
//		  action:@selector(ButtonPressed:)
//forControlEvents:UIControlEventTouchUpInside];
//	
//	[t release];
	
	QAMultiChoiceQuestion *q = [BrainOO questionAtCurrentPosition];
	NSArray *questionarray = [q getAnswerArrayWithTrueCount:1 andFalseCount:2];
	// Make 3 buttons...
	for (int i=0; i < [questionarray count]; i++) {
		// Make the button and set it all up
		UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
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
		
		NSString *str = @"close_64.png";
		[b setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
		str = @"star_64.png";
		[b setImage:[UIImage imageNamed:str] forState:UIControlStateSelected];
		str = @"close_64.png";
		[b setImage:[UIImage imageNamed:str] forState:UIControlStateHighlighted];

		//
		// Set background image
		//
		UIImage *blueImage = [UIImage imageNamed:@"blueButton.png"];
		UIImage *blueButtonImage = [blueImage stretchableImageWithLeftCapWidth:48 topCapHeight:0];
		[b setBackgroundImage:blueButtonImage forState:UIControlStateNormal];

		[ChoiceButtons addObject:b];
		

		
		[b setFrame:CGRectMake(12, 170+i*72, 300, 72)];
		
		[self.view addSubview:b];
		[b setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		b.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		b.titleLabel.numberOfLines = 0;
		
		[b release];

		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(12+32, 0+i*72, 250, 72)];
//		[l retain];
//		l.textColor = [UIColor blackColor];
//		//b.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.25*(i%2)+0.25 ];
//		//l.backgroundColor = [UIColor clearColor];
//		l.lineBreakMode = UILineBreakModeWordWrap;
//		l.numberOfLines = 0;
//		//l.text = b.titleLabel.text;
		[ChoiceLabels addObject:l];
//		//UIFont *aFont = [UIFont fontWithName:@"Marker Felt" size:12];
//		//l.font = aFont;
		
		
		//[self.view addSubview:l];
		[l release];
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
	[ChoiceLabels release];
	[BrainOO release];
    [super dealloc];
}

@end
