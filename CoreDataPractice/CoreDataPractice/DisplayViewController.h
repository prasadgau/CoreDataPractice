//
//  DisplayViewController.h
//  CoreDataPractice
//
//  Created by colors on 08/10/13.
//  Copyright (c) 2013 colors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataTable.h"

@protocol DisplayVCDelegate <NSObject>

- (NSFetchedResultsController *)retrieveDataFromDatabase;

@end

@interface DisplayViewController : UIViewController<UITableViewDataSource,UITextFieldDelegate,NSFetchedResultsControllerDelegate>{

    
    IBOutlet UITableView *displayTable;
    NSMutableArray *dataArray;
    
    NSFetchedResultsController *fetchedResultsController;
    
    id<DisplayVCDelegate> delegate;
}
@property(nonatomic,strong) id<DisplayVCDelegate> delegate;
@end
