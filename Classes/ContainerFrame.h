//
//  ContainerFrame.h
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// This is view that encapsulate other view objects and arranges them in some order
// and presents them in a pretty way. 
// For example: One could add two buttons to it and they will both have their sizes 
// changed to fit inside the frame.
// 
// FIXME: Add a protocol "encapsulate" which has a method call encapsulate that adds
//        objects to itself. 

#import <UIKit/UIKit.h>


@interface ContainerFrame : UIView {
	
	NSInteger containerType; // The ID of the container, ie "Answer container", etc...
	NSMutableArray *objects; // A list of objects added to this container

}

@property (nonatomic,retain) 	NSMutableArray *objects;

@property (nonatomic,assign) NSInteger containerType;

// Rearrange all objects in container
- (void) sortContainer;

// Add objects and change their size to fit inside the frame
- (void) addObject:(UIView *) obj;

//- (void) addSubview:(UIView *)view;

// Remove object
- (void) removeObject:(UIView *) obj;

// Check frame intersection
- (BOOL) checkBounds:(CGRect)otherRect; 

@end
