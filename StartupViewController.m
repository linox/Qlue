//
//  StartupViewController.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemsViewController.h"
#import "StartupViewController.h"


@implementation StartupViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	
	[[self navigationItem] setTitle:@"Home"];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.hidden = YES;
	
	UIImage *blueImage = [UIImage imageNamed:@"button.png"];
    UIImage *blueButtonImage = [blueImage stretchableImageWithLeftCapWidth:48 topCapHeight:0];
	UIButton *myButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	UIFont *displayFont = [UIFont fontWithName:@"Marker Felt" size:24];
	myButton.titleLabel.font = displayFont;
	[myButton setTitle:@"Start game" forState:UIControlStateNormal];
    [myButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
	[myButton setFrame:CGRectMake(80, 200, 156, 48)];
	[myButton addTarget:self 
		  action:@selector(playButtonClicked:)
			forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:myButton];
	[myButton release];
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DarkWoodenWall.jpg"]];
	self.view.backgroundColor = [UIColor clearColor];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) playButtonClicked:(id) sender {

	ItemsViewController *itemsViewController = [[ItemsViewController alloc] init];
	
	[[self navigationController] pushViewController:itemsViewController
                                           animated:YES];
	[ItemsViewController release];

}

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
