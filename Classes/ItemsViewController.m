//
//  ItemsViewController.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizapAppDelegate.h"
#import "ItemsViewController.h"
#import	"QuizStore.h"
#import "QuizBrainOO.h"
#import "RequirementsViewController.h"
#import "QuizapEditQuizViewController.h"
#import "QuizSelectedViewController.h"

@implementation ItemsViewController

- (id)init {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
	
	if (self) {
        for (int i = 0; i < 1; i++) {
            [[QuizStore defaultStore] createQuiz];
			
			
        }
		
//		// Create a new bar button item that will add
//		// quizes to ItemsViewController
//		UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
//								initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//								target:self
//								action:@selector(addNewQuiz:)];
//		// Set this bar button item as the right item in the navigationItem
//		[[self navigationItem] setRightBarButtonItem:bbi];
//		// The navigationItem retains its buttons, so bbi can be released
//		[bbi release];
	}
	self.view.backgroundColor = [UIColor clearColor];
	
    return self;
}

- (UIView *)headerView
{
    // If we haven't loaded the headerView yet...
    if (!headerView) {
        // Load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)sec
{
    return [self headerView];
}
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)sec
{
    return [[self headerView] bounds].size.height;
}

- (void)toggleEditingMode:(id)sender
{
    // If we are currently in editing mode...
    if ([self isEditing]) {
        // Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // Change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // Enter editing mode
        [self setEditing:YES animated:YES];
	} 
}

- (IBAction)addNewQuiz:(id)sender
{
	QuizStore *qs = [QuizStore defaultStore];
	
	// No quiz can currently be selected....
	qs.currentQuizIndex = -1;
	
    //[[QuizStore defaultStore] create];
    // tableView returns the controller's view
	QuizapEditQuizViewController *qe = [[QuizapEditQuizViewController alloc] init];
	
	[[self navigationController] pushViewController:qe
                                           animated:YES];
	
	[qe autorelease];
	
    //[[self tableView] reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	// Fade in navigation bar
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	
	QuizStore *qs = [QuizStore defaultStore];
	
	qs.currentQuizIndex = -1;
	
	[[self navigationItem] setTitle:@"Quizes"];
	[[self tableView] reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[QuizStore defaultStore] allQuizes] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Check for a reusable cell first, use that if it exists
    UITableViewCell *cell =
	[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:@"UITableViewCell"] autorelease];
	}
    // Set the text on the cell with the description of the possession
    // that is at the nth index of possessions, where n = row this cell
    // will appear in on the tableview
    QuizBrainOO *b = [[[QuizStore defaultStore] allQuizes]
					 objectAtIndex:[indexPath row]];

	
	[[cell textLabel] setText:[b title]];
	NSString *detailText = [NSString stringWithFormat:@"Saved score: %d", b.savedScore];
	[[cell detailTextLabel] setText:detailText];

	
	return cell;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	QuizStore *qs = [QuizStore defaultStore];

	qs.currentQuizIndex = [indexPath row]; 

	
    //QuizapView2Controller *detailViewController =
	//[[[QuizapView2Controller alloc] init] autorelease];
	//
	//detailViewController.BrainOO = [[qs allQuizes] objectAtIndex:qs.currentQuizIndex];
	
	QuizSelectedViewController *detailViewController = 
		[[[QuizSelectedViewController alloc] init] autorelease];
	
	//
	// Up until now the background of navcontroller has been transparent, letting a "fixed"
	// image show constantly in the background between view switches... Here I want the
	// everything to slide when switching view so it signals to the user that we entered
	// a new state in the app. So set the background of this view to the same image as in
	// superviews instead of being transparent...
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DarkWoodenWall.jpg"]]; 
	detailViewController.view.backgroundColor = [UIColor clearColor];
	
	//
	// FIXME: This checks for the dependencies of each quiz. It's kind of backwards... 
	//        ...it checks all loaded quizes and looks to see if they are furfilled.
	//        Then it compares number of furfilled dependencies to the total amount of
	//        dependencies (there might be dependencies on quizes that are not loaded).
	//        It would be better to do it the other way around, ie check each required
	//        dependency and see if they are found in the loaded quizes...
	NSDictionary *depends = [[[qs allQuizes] objectAtIndex:qs.currentQuizIndex] depends];
	NSInteger unfurfilledDeps = [depends count];
	for (QuizBrainOO *b in [qs allQuizes] ) {
		
		NSString *minscore = [depends objectForKey:b.ID];
		if (minscore != nil) {
			if (b.savedScore < [minscore intValue]) {
				NSLog(@"You need a score of %@ in the %@ quiz first!", minscore, b.ID);
			} else {
				NSLog(@"Congratulations you may run this quiz!");
				unfurfilledDeps = unfurfilledDeps - 1;
			}
			
		} else {
			NSLog(@"Theres no depency to %@ for this quiz", b.ID);
			//NSLog(@"This quiz requires that you complete the quiz %@ first!", b.ID);
		}
	
	} 
	NSLog(@"Unfurfilled = %d", unfurfilledDeps);

	if (unfurfilledDeps <= 0) { 
		// Push it onto the top of the navigation controller's stack
		
		
		
		// Slide selected item in...
		[[self navigationController] pushViewController:detailViewController
                                           animated:YES];

	} else {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sorry!" 
														 message:@"This quiz requires that you complete another quiz first!" 
														delegate:self
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:@"Details",nil] autorelease];
		[alert show];

		
	}
	
	
	
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        QuizStore *qs = [QuizStore defaultStore];
        NSArray *quizes = [qs allQuizes];
        QuizBrainOO *b = [quizes objectAtIndex:[indexPath row]];
        [qs removeQuiz:b];
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:YES];
	} 
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
	if (buttonIndex > 0) {
		RequirementsViewController *requirementsViewController =
		[[[RequirementsViewController alloc] init] autorelease];
		[[self navigationController] pushViewController:requirementsViewController
											   animated:YES];
	}

}


@end
