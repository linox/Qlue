//
//  QuizStore.m
//  Quizap
//
//  Created by Martin Dahlgren on 2011-10-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizStore.h"
#import "../SBJson/SBJson.h"

static QuizStore *defaultStore = nil;

@implementation QuizStore

@synthesize currentQuizIndex;

+ (QuizStore *)defaultStore
{
    if (!defaultStore) {
        // Create the singleton
        defaultStore = [[super allocWithZone:NULL] init];
	}
    return defaultStore;
}
// Prevent creation of additional instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init {
    // If we already have an instance of PossessionStore...
    if (defaultStore) {
        // Return the old one
        return defaultStore;
    }
    self = [super init];
	
	if (self) {
        //allQuizes = [[NSMutableArray alloc] init];
		QuizDB = [[NSMutableDictionary alloc] init];
	}
	
    return self;
}

- (id)retain
{
	// Do nothing
    return self;
}
- (void)release
{
    // Do nothing
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (QuizBrainOO *) quizWithKey:(NSString *) key{
	return [QuizDB objectForKey:key];
}


- (NSArray *)allQuizes
{
	return [QuizDB allValues];
    //return allQuizes;
}

// Shamelessly stolen from ScaryBugs tutorial by Ray Wenderlich
//- (NSMutableArray *)loadQuizes {
//	
//    NSMutableArray *retval = [NSMutableArray array];
//	
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *publicDocumentsDir = [paths objectAtIndex:0];   
//	
//    NSError *error;
//    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:publicDocumentsDir error:&error];
//    if (files == nil) {
//        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
//        return retval;
//    }
//	
//    for (NSString *file in files) {
//        if ([file.pathExtension compare:@"qiz" options:NSCaseInsensitiveSearch] == NSOrderedSame) {        
//            NSString *fullPath = [publicDocumentsDir stringByAppendingPathComponent:file];
//            [retval addObject:fullPath];
//        }
//    }
//	
//    return retval;
//	
//}

- (void) saveCurrentQuiz {
	
	QuizBrainOO *b = [[self allQuizes] objectAtIndex:self.currentQuizIndex];

	NSString *theScore = [NSString stringWithFormat:@"%d", b.savedScore];//[b.getScore stringValue];
	NSString *json =  b.json;

	SBJsonParser *p = [[SBJsonParser alloc] init];

	SBJsonWriter *w = [[SBJsonWriter alloc] init];
	w.humanReadable = YES;
	w.sortKeys = YES;
	
	
	id object = [p objectWithString:json];
	NSMutableDictionary *d = [object objectForKey:@"Quiz"];
	
	[d setObject:theScore forKey:@"Score"];
	
	b.json = [w stringWithObject:object];
	[d setObject:b.ID forKey:@"ID" ];
	
	NSString *quizid = [d objectForKey:@"ID"];
	NSLog(@"Saved! ID=%@ json: %@", quizid, b.json);
	
	[self  writeToDocumentsDirectory:quizid withContentsOfString:b.json];

}

-(void) writeToDocumentsDirectory:(NSString *)fileName withContentsOfString:(NSString *) contents {
	//get the documents directory:

	NSArray *paths = NSSearchPathForDirectoriesInDomains
		(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the documents directory:
	NSString *filePath = [NSString stringWithFormat:@"%@/%@.qiz", documentsDirectory,fileName];
	NSLog(@"SAVE FILE TO:%@",filePath); 
	//create content - four lines of text

	//NSBundle *bundle = [NSBundle mainBundle];
	//NSString *filePath = [bundle pathForResource:fileName ofType:@"qiz"];
	
	//save content to the directory
	[contents writeToFile:filePath
			  atomically:NO 
				encoding:NSStringEncodingConversionAllowLossy 
				   error:nil];
	
}



- (QuizBrainOO *) jsonStringToQuiz:(NSString *)str {
	
	SBJsonParser *p = [[SBJsonParser alloc] init];
	SBJsonWriter *w = [[SBJsonWriter alloc] init];
	w.humanReadable = YES;
	w.sortKeys = YES;
	
	NSMutableDictionary *d;
	
	//An array that holds the questions objects.
	// We use it later for init call to QuizBrain
	NSMutableArray *initarray = [[NSMutableArray alloc] init];
	QuizBrainOO	*b = nil;
	QAMultiChoiceQuestion *mq;
	NSString *tmpstr;
	NSString *qTitle;
	NSMutableDictionary *deps = nil;
	
	id object = [p objectWithString:str];
	
	if (object) {
		
		// Parse Quizes...
		d = [object objectForKey:@"Quiz"];
		if(d != nil) {
			qTitle = [d objectForKey:@"QuizTitle"];
			NSLog(@"Key Found! Title=%@", qTitle);
			deps = [d objectForKey:@"Depends"];
			// Parse Questions....
			NSArray *a = [d objectForKey:@"Questions"];
			id questionitem;
			for(questionitem in a) {
				
				tmpstr = [questionitem objectForKey:@"QuestionTitle"];
				mq = [[QAMultiChoiceQuestion alloc] initWithQuestion:tmpstr];
				
				NSLog(@"First Question=%@", tmpstr);
				
				NSArray *q = [questionitem objectForKey:@"Answers"];
				id answeritem;
				for(answeritem in q) {
					//FIXME: Change order of true/false parse so that the "default" answer is true...
					tmpstr = [answeritem objectForKey:@"True"];
					if ([tmpstr isEqual:@"YES"]) {
						tmpstr = [answeritem objectForKey:@"AnswerTitle"];
						[mq addChoice:tmpstr withBoolValue:YES];
						NSLog(@"Added true answer: %@", tmpstr);
					} else {
						tmpstr = [answeritem objectForKey:@"AnswerTitle"];
						[mq addChoice:tmpstr withBoolValue:NO];
						NSLog(@"Added false answer: %@", tmpstr);
					}
					
					
				}
				
				[initarray addObject:mq];
				[mq release];
				mq = nil;
				
			} // End of questions parsing loop
			
			b = [[QuizBrainOO alloc] initWithQuestions:initarray]; //FIXME: Use autorelease?
			[initarray release];
			initarray = nil;
			
			b.title = qTitle;
			b.depends = deps;
			NSLog(@"deps = %@", deps);
			
			NSString *theScore = [d objectForKey:@"Score"];
			
			if (theScore != nil) {
				//b.title  = [NSString stringWithFormat:@"%@   (%@)", qTitle, theScore];
				b.savedScore = [theScore intValue];
			} else {
				
				b.savedScore = 0;
			}
			
			NSString *theID = [d objectForKey:@"ID"];
			//if (theID != nil) {
				b.ID = theID; // DEBUG: might be nil!!
				NSLog(@"theID = %@", theID);
			//} else {
			//	b.ID = @"quizgame0";
			//}


			b.json = [w stringWithObject:object];
			[b autorelease];
			
		}		
		
	} else {
		NSLog(@"Failed to parse JSON!");
	}
	
	
	return b;
	
}

// If a ID is supplied we overwrite a quiz....
- (QuizBrainOO *) createQuizFromString:(NSString *)str withID:(NSString *) ID {
	QuizBrainOO *b = [self jsonStringToQuiz:str];

	if (b != nil) { 
		if (ID != nil) {
			b.ID = ID;
			//Check to see if the ID was set in the json file supplied to jsonStringToQuiz
		} else if (b.ID == nil) {
			// Set a default ID
			b.ID = @"quizgame0";
		}
	
		[QuizDB setObject:b forKey:b.ID];
		[self writeToDocumentsDirectory:b.ID withContentsOfString:str];
	}
	
	return b;
} 


- (QuizBrainOO *) loadQuizFromFile:(NSString *) filePath
{
	
	//
	// First look for the file in documents folder...
	//
	NSArray *paths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *textFilePath = [documentsDirectory stringByAppendingPathComponent:filePath];
	NSString *fullFilePath = [NSString stringWithFormat:@"%@.qiz", textFilePath];
	NSString *fileContents = [NSString stringWithContentsOfFile:fullFilePath];
	
	// If file not found in documents dir, look in resource...
	if (fileContents == nil) {
		NSBundle *bundle = [NSBundle mainBundle];
		textFilePath = [bundle pathForResource:filePath ofType:@"qiz"];
		fileContents = [NSString stringWithContentsOfFile:textFilePath];
		
		if (fileContents == nil) {
			return nil;
		}

	}
	
	QuizBrainOO *b = [self jsonStringToQuiz:fileContents];
	
	if (b != nil) {
		b.ID = filePath;
		NSLog(@"quizID = %@", filePath);

	}
	
	return b;
	
//	
//	SBJsonParser *p = [[SBJsonParser alloc] init];
//	SBJsonWriter *w = [[SBJsonWriter alloc] init];
//	w.humanReadable = YES;
//	w.sortKeys = YES;
//	
//	NSMutableDictionary *d;
//
//	//An array that holds the questions objects.
//	// We use it later for init call to QuizBrain
//	NSMutableArray *initarray = [[NSMutableArray alloc] init];
//	QuizBrainOO	*b = nil;
//	QAMultiChoiceQuestion *mq;
//	NSString *tmpstr;
//	NSString *qTitle;
//	NSMutableDictionary *deps = nil;
//	
//	id object = [p objectWithString:fileContents];
//	
//	if (object) {
//		
//		// Parse Quizes...
//		d = [object objectForKey:@"Quiz"];
//		if(d != nil) {
//			qTitle = [d objectForKey:@"QuizTitle"];
//			NSLog(@"Key Found! Title=%@", qTitle);
//			deps = [d objectForKey:@"Depends"];
//			// Parse Questions....
//			NSArray *a = [d objectForKey:@"Questions"];
//			id questionitem;
//			for(questionitem in a) {
//				
//				tmpstr = [questionitem objectForKey:@"QuestionTitle"];
//				mq = [[QAMultiChoiceQuestion alloc] initWithQuestion:tmpstr];
//			
//				NSLog(@"First Question=%@", tmpstr);
//				
//				NSArray *q = [questionitem objectForKey:@"Answers"];
//				id answeritem;
//				for(answeritem in q) {
//					//FIXME: Change order of true/false parse so that the "default" answer is true...
//					tmpstr = [answeritem objectForKey:@"True"];
//					if ([tmpstr isEqual:@"YES"]) {
//						tmpstr = [answeritem objectForKey:@"AnswerTitle"];
//						[mq addChoice:tmpstr withBoolValue:YES];
//						NSLog(@"Added true answer: %@", tmpstr);
//					} else {
//						tmpstr = [answeritem objectForKey:@"AnswerTitle"];
//						[mq addChoice:tmpstr withBoolValue:NO];
//						NSLog(@"Added false answer: %@", tmpstr);
//					}
//
//													  
//				}
//				
//				[initarray addObject:mq];
//				[mq release];
//				mq = nil;
//				
//			} // End of questions parsing loop
//			
//			b = [[QuizBrainOO alloc] initWithQuestions:initarray]; //FIXME: Use autorelease?
//			[initarray release];
//			initarray = nil;
//			
//			b.title = qTitle;
//			b.depends = deps;
//			NSLog(@"deps = %@", deps);
//
//			NSString *theScore = [d objectForKey:@"Score"];
//			
//			if (theScore != nil) {
//				//b.title  = [NSString stringWithFormat:@"%@   (%@)", qTitle, theScore];
//				b.savedScore = [theScore intValue];
//			} else {
//				
//				b.savedScore = 0;
//			}
//			
//			b.ID = filePath;
//			[d setObject:filePath forKey:@"ID"];
//
//			b.json = [w stringWithObject:object];
//			NSLog(@"quizID = %@", filePath);
//
//			[b autorelease];
//			
//		}		
//
//	} else {
//		NSLog(@"Failed to parse JSON!");
//	}
//
//	
//	return b;

}

- (void) createQuiz
{
	QuizBrainOO *b = nil;
	
	// If a quiz is allready created we do nothing...
	if ([[self allQuizes] count] > 0) {
		return;
	}
		
	//NSBundle *bundle = [NSBundle mainBundle];

	//
	// Create the default "demo quiz" ..
	//
	//NSString *textFilePath = [bundle pathForResource:@"quizdemo" ofType:@"qiz"];
	if (b = [self loadQuizFromFile:@"quizdemo"]) {
		// Loading from file was successful!
		[QuizDB setObject:b forKey:@"quizdemo"];
	} else {
			
		//First question
		QAMultiChoiceQuestion *mq = [[QAMultiChoiceQuestion alloc] initWithQuestion:@"Inom farmakologin används ett begrepp för att mäta den terapeutiska nivån av ett läkemedel. Vad betyder TDM?" andAnswer:@"The short answer is Therapeutic Drug Monitoring"];
		[mq addChoice:@"The long answer to that question is that TDM stands for Transitional Drug Manipulation. If you look in the book on chapter 6 page 55 you can read more. " withBoolValue:NO];
		[mq addChoice:@"Read Illustrated Pharmacolagy 9th ed, chapter 3, pages 55-60." withBoolValue:NO];
		NSMutableArray *initarray = [NSMutableArray arrayWithObjects:mq, nil];
		[initarray retain];
		[mq release]; //mq is retained in initializer of Brain...
			
		//Second question
		mq = [[QAMultiChoiceQuestion alloc] initWithQuestion:@"Vad betyder HBT?" andAnswer:@"Homo Bi Transexuell"];
		[mq addChoice:@"Hög basal topografi" withBoolValue:NO];
		[mq addChoice:@"Hetero Bakgrund Teater" withBoolValue:NO];
		[initarray addObject:mq];
		[mq release];
			
			
		b = [[QuizBrainOO alloc] initWithQuestions:initarray]; //FIXME: Use autorelease?
		b.title = @"Demo";
			
		//[allQuizes addObject:b];
		[QuizDB setObject:b forKey:@"quizdemo"];
		[initarray release];
		[b release];		
	}
	
	//
	// Look for any quizgameX.qiz and load them too...
	//
	int i;
	for (i = 0; i<10; i++) {
		NSString *filename = [NSString stringWithFormat:@"quizgame%d", i];
		//NSString *textFilePath = [bundle pathForResource:filename ofType:@"qiz"];
	    b = [self loadQuizFromFile:filename];
		if (b != nil) {
			NSLog(@"%@.qiz found!", filename);
			
			//b.title = filename;
			//[allQuizes addObject:b];
			[QuizDB setObject:b forKey:filename];
			// Make a copy of the file to Documents directory.
			//[self writeToDocumentsDirectory:filename withContentsOfString:b.json];
		} else {
			NSLog(@"%@.qiz not found!", filename);

		}
	}

}

- (void)removeQuiz:(QuizBrainOO *)b
{
    [QuizDB removeObjectForKey:b.ID];
}

- (void)updateQuiz:(QuizBrainOO *)b
{
    [QuizDB setObject:b forKey:b.ID];
}


// FIXME: This is a singleton and release does nothing so this method never gets called? so remove it...
- (void) dealloc
{
	[QuizDB release];
	[super dealloc];
}


@end
