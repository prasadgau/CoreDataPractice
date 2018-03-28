//
//  ViewController.h
//  CoreDataPractice
//
//  Created by colors on 08/10/13.
//  Copyright (c) 2013 colors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataTable.h"
#import "DisplayViewController.h"

@interface ViewController : UIViewController<UITextFieldDelegate,DisplayVCDelegate>{

    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    
    DisplayViewController *displayVC;
}
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(IBAction)loginButtonSelected:(id)sender;
- (NSFetchedResultsController *)retrieveDataFromDatabase;
@end
