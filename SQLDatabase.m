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

+ (SQLDatabase *) databaseInMemory {
    sqlite3 *lowLevelDatabase = NULL;
    int errorCode = sqlite3_open("", &lowLevelDatabase);
    if(errorCode != SQLITE_OK)
	[SQLDatabase throwAndCloseDatabase: lowLevelDatabase];
    
    SQLDatabase *result = [SQLDatabase alloc];
    result.lowLevelDatabase = lowLevelDatabase;
    return result;
}


+ (SQLDatabase *) databaseInFile: (NSString *) filename {
    sqlite3 *lowLevelDatabase = NULL;
    int errorCode = sqlite3_open([filename UTF8String], &lowLevelDatabase);
    if(errorCode != SQLITE_OK)
	[SQLDatabase throwAndCloseDatabase: lowLevelDatabase];
    
    SQLDatabase *result = [SQLDatabase alloc];
    result.lowLevelDatabase = lowLevelDatabase;
    return result;
}


+ (void) throwAndCloseDatabase: (sqlite3 *) lowLevelDatabase {
    const char *utf8 = sqlite3_errmsg(lowLevelDatabase);
    NSString *string = [NSString stringWithUTF8String: utf8];
    (void) sqlite3_close(lowLevelDatabase);
    
    NSError *error = [SQLDatabase errorWithDescription: string];
    
    NSMutableDictionary *userInfo
	= [NSMutableDictionary dictionaryWithCapacity: 1];
    [userInfo setObject: error
	      forKey: @"Error"];
    NSException *exception = [NSException exceptionWithName: @"SQLite"
					  reason: string
					  userInfo: userInfo];
    @throw(exception);
}


+ (NSError *) errorWithDescription: (NSString *) description {
    NSMutableDictionary *userInfo = nil;
    if(description) {
	userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
	[userInfo setObject: description
		  forKey: NSLocalizedFailureReasonErrorKey];
    }
    return [NSError errorWithDomain: @"SQLite"
		    code: 1
		    userInfo: userInfo];
}

@end
