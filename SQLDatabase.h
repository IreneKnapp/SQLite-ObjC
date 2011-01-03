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
    BOOL open;
}
@property (assign) sqlite3 *lowLevelDatabase;

+ (SQLDatabase *) databaseInMemory;
+ (SQLDatabase *) databaseInFile: (NSString *) filename;
+ (void) throwAndCloseDatabase: (sqlite3 *) lowLevelDatabase;
+ (NSError *) errorWithDescription: (NSString *) description;
@end
