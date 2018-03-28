//
//  DataTable.h
//  CoreDataPractice
//
//  Created by colors on 08/10/13.
//  Copyright (c) 2013 colors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataTable : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;

@end
