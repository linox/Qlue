//
//  ContainerFrame.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContainerFrame.h"


@implementation ContainerFrame
@synthesize objects, containerType;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		objects = [[NSMutableArray alloc] init];
    }

	self.backgroundColor = [UIColor colorWithRed:(203.0/255.0) green:(42.0/255.0) blue:(20.0/255.0) alpha:0.0];
	return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code.
	//CGContextRef context = UIGraphicsGetCurrentContext();
	
	//CGContextSetLineWidth(context, 2.0);
	
	
	
	//CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(203.0/255.0) green:(42.0/255.0) blue:(20.0/255.0) alpha:1.0].CGColor);
	
	//CGRect rectangle = [self bounds];//CGRectMake(60,170,200,80);
	
	//CGContextAddRect(context, rectangle);
	
	//CGContextStrokePath(context);
	
}

// Look for overlapping views wich means objects has crashed
- (BOOL) checkBounds:(CGRect)otherRect {
	
	CGRect myRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
	
	if(CGRectIntersectsRect(myRect, otherRect)) {
		return YES;
	}
	
	
	return NO;
	
}

// Iterate the objects array and change size and positions of objects
- (void) sortContainer {
	
	UIView *v;
	
	// Set the size according to number of objects in container...
	CGFloat newsize = self.frame.size.width / [objects count];
	CGFloat selfx = self.frame.origin.x + 4; // The left side of container with offset 
	CGFloat selfy = self.frame.origin.y;


	
	CGFloat newx = 0;
	for (v in objects) {
		[v setFrame:CGRectMake(selfx + newx, selfy+10, newsize-8, self.frame.size.height-20) ]; // Resize to fit frame
		newx = newx + newsize;
	}
	
}

//FIXME: Overide addSubview instead and put this code there...
- (void) addObject:(UIView *) obj {
	// FIXME: Add a check to see if obj is already part of container... then it should not be added again.
	[objects addObject:obj];
	[self sortContainer];
	
}

- (void) removeObject:(UIView *) obj {
	
	//remove obj from NSMutableArray  
	[objects removeObject:obj];
	[self sortContainer];
	
}





- (void)dealloc {
	[objects release];
    [super dealloc];
}


@end
