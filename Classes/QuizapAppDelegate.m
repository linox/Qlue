//
//  QuizapAppDelegate.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-09-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizapAppDelegate.h"
#import "QuizapViewController.h"


@implementation QuizapAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;
@synthesize GlobalBrainOO;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	[self.window addSubview:[navigationController view]];
	// Set the view controller as the window's root view controller and display.
    //self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
	
	
	//First question
	QAMultiChoiceQuestion *mq = [[QAMultiChoiceQuestion alloc] initWithQuestion:@"Vad betyder TDM?" andAnswer:@"Therapeutic Drug Monitoring"];
	[mq addChoice:@"Transitional Drug Manipulation" withBoolValue:NO];
	[mq addChoice:@"Trancendental Diagnosis Map" withBoolValue:NO];
	NSMutableArray *initarray = [NSMutableArray arrayWithObjects:mq, nil];
	[initarray retain];
	[mq release]; //mq is retained in initializer of Brain...
	
	//Second question
	mq = [[QAMultiChoiceQuestion alloc] initWithQuestion:@"Vad betyder HBT?" andAnswer:@"Homo Bi Transexuell"];
	[mq addChoice:@"Hög basal topografi" withBoolValue:NO];
	[mq addChoice:@"Hetero Bakgrund Teater" withBoolValue:NO];
	[initarray addObject:mq];
	
	
	GlobalBrainOO = [[QuizBrainOO alloc] initWithQuestions:initarray];
	[initarray release];
	
	[mq release];
	
    return YES;
}

-(void) resetGame {
	[self.GlobalBrainOO reset];
	[self.viewController reset];
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[GlobalBrainOO release];
	[navigationController release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
