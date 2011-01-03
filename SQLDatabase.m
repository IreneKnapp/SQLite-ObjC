//
//  SQLDatabase.m
//  SQLite-ObjC
//
//  Created by Dan Knapp on 1/2/11.
//  Copyright 2011 Dan Knapp. All rights reserved.
//

#import "SQLDatabase.h"


@implementation SQLDatabase
@synthesize lowLevelDatabase;
@synthesize isOpen;

+ (SQLDatabase *) databaseInMemory {
    sqlite3 *lowLevelDatabase = NULL;
    int errorCode = sqlite3_open("", &lowLevelDatabase);
    if(errorCode != SQLITE_OK)
	[SQLDatabase throwAndCloseDatabase: lowLevelDatabase];
    
    SQLDatabase *result = [SQLDatabase alloc];
    result.lowLevelDatabase = lowLevelDatabase;
    result.isOpen = YES;
    return result;
}


+ (SQLDatabase *) databaseInFile: (NSString *) filename {
    sqlite3 *lowLevelDatabase = NULL;
    int errorCode = sqlite3_open([filename UTF8String], &lowLevelDatabase);
    if(errorCode != SQLITE_OK)
	[SQLDatabase throwAndCloseDatabase: lowLevelDatabase];
    
    SQLDatabase *result = [SQLDatabase alloc];
    result.lowLevelDatabase = lowLevelDatabase;
    result.isOpen = YES;
    return result;
}


+ (void) throwAndCloseDatabase: (sqlite3 *) lowLevelDatabase {
    const char *utf8 = sqlite3_errmsg(lowLevelDatabase);
    NSString *string = [NSString stringWithUTF8String: utf8];
    (void) sqlite3_close(lowLevelDatabase);
    
    [SQLDatabase throwExceptionWithDescription: string];
}


+ (void) throwExceptionWithDescription: (NSString *) description {
    NSMutableDictionary *errorUserInfo = nil;
    if(description) {
	errorUserInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
	[errorUserInfo setObject: description
		       forKey: NSLocalizedFailureReasonErrorKey];
    }
    NSError *error = [NSError errorWithDomain: @"SQLite"
			      code: 1
			      userInfo: errorUserInfo];
    
    NSMutableDictionary *exceptionUserInfo
	= [NSMutableDictionary dictionaryWithCapacity: 1];
    [exceptionUserInfo setObject: error
		       forKey: @"Error"];
    NSException *exception = [NSException exceptionWithName: @"SQLite"
					  reason: description
					  userInfo: exceptionUserInfo];
    
    @throw(exception);
}


- (void) throwUnlessOpen {
    if(!isOpen) {
	[SQLDatabase throwExceptionWithDescription: @"Database is not open."];
    }
}


- (void) close {
    [self throwUnlessOpen];
    
    int result = sqlite3_close(lowLevelDatabase);
    if(result == SQLITE_BUSY) {
	[SQLDatabase throwExceptionWithDescription:
	  @"Database is busy and cannot be closed."];
    }

    isOpen = NO;
}

@end
