//
//  DisplayViewController.m
//  CoreDataPractice
//
//  Created by colors on 08/10/13.
//  Copyright (c) 2013 colors. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSFetchedResultsController *)fetchedResultControllerMethod
{
    NSLog(@"fetchedResultsController");
    fetchedResultsController = [delegate retrieveDataFromDatabase];
    fetchedResultsController.delegate = self;
   
    return fetchedResultsController;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return [dataArray count];
    NSArray *arr = [[self fetchedResultControllerMethod] sections];
    id  <NSFetchedResultsSectionInfo>  sectionInfo =  [arr objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    DataTable *dataTable=[[self fetchedResultControllerMethod] objectAtIndexPath:indexPath];
    cell.textLabel.text=dataTable.username;
    cell.detailTextLabel.text = dataTable.password;

    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
		if (![context save:&error])
        {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
        
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
   	[displayTable reloadData];
    
}
@end
