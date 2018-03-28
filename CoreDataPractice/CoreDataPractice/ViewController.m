//
//  ViewController.m
//  CoreDataPractice
//
//  Created by colors on 08/10/13.
//  Copyright (c) 2013 colors. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}
-(IBAction)loginButtonSelected:(id)sender{
    [self insertDataUsername:usernameField.text Password:passwordField.text];
    [self performSegueWithIdentifier:@"DisplayVC" sender:nil];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"DisplayVC"]) {
        displayVC = [segue destinationViewController];
        displayVC.delegate = self;
    }
}
-(void)insertDataUsername:(NSString *)uName Password:(NSString *)pWord{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    DataTable *dataTable = [NSEntityDescription insertNewObjectForEntityForName:@"DataTable" inManagedObjectContext:context];
    dataTable.username = uName;
    dataTable.password = pWord;
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
- (NSFetchedResultsController *)retrieveDataFromDatabase
{
    NSLog(@"retrieveDateFromDB");
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DataTable" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES];
    NSArray *sortDescriptorArray = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setSortDescriptors:sortDescriptorArray];
    [fetchRequest setEntity:entity];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Error performing fetch:%@",error);
    }
//    NSManagedObjectContext *moc = self.managedObjectContext;
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountsTable" inManagedObjectContext:moc];
//    
//    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"newAccount" ascending:NO];
//    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"feature" ascending:YES];
//    NSSortDescriptor *sd3 = [[NSSortDescriptor alloc] initWithKey:@"rowName" ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1,sd2,sd3,nil];
//    
//    
//   // NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(apps=%@)",appsName];
//    // NSLog(@"The predicate:%@",predicate);
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:entity];
//    [fetchRequest setPredicate:predicate];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    [fetchRequest setFetchBatchSize:10];
//    
//    
//    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:@"newAccount" cacheName:nil];
//    
//    NSError *error = nil;
//    if (![fetchedResultsController performFetch:&error])
//    {
//        NSLog(@"Error performing fetch: %@", error);
//    }
    
    
    return fetchedResultsController;
    
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator !=nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"PracticeDataModel" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    return managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PracticeDataModel.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[storeUrl path]])
    {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"PracticeDataModel" withExtension:@"sqlite"];
        
        
        if (defaultStoreURL)
        {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeUrl error:NULL];
        }
    }
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption,nil];
    
    NSError *error = nil;
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
   
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext1 = [self managedObjectContext];
    if (managedObjectContext1 != nil)
    {
        if ([managedObjectContext1 hasChanges] && ![managedObjectContext1 save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
