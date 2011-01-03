//  -*- mode: objc -*-
//  SQLDatabase.h
//  SQLite-ObjC
//
//  Created by Dan Knapp on 1/2/11.
//  Copyright 2011 Dan Knapp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "sqlite3.h"


@interface SQLDatabase : NSObject {
    sqlite3 *lowLevelDatabase;
    BOOL isOpen;
}
@property (assign) sqlite3 *lowLevelDatabase;
@property (assign) BOOL isOpen;

+ (SQLDatabase *) databaseInMemory;
+ (SQLDatabase *) databaseInFile: (NSString *) filename;
+ (void) throwAndCloseDatabase: (sqlite3 *) lowLevelDatabase;
+ (void) throwExceptionWithDescription: (NSString *) description;
- (void) throwUnlessOpen;
- (void) close;
@end
