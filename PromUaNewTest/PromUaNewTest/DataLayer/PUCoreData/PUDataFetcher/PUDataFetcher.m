//
//  PUDataFetcher.m
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUDataFetcher.h"


@interface PUDataFetcher ()
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation PUDataFetcher

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - shared
+ (instancetype)shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
#pragma mark -


#pragma mark - fetch some Objects by title
- (NSArray *)fetchObjectsByTitle:(NSString *)entityTitle {
    NSArray *valuesArray = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityTitle inManagedObjectContext:self.managedObjectContext]];
    NSArray *fetchedValues = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([fetchedValues count] > 0)
        valuesArray = fetchedValues;
    
    return valuesArray;
}
#pragma mark -


#pragma mark - fetch some Objects by title and fieldName and id
- (NSArray *)fetchObjectsByTitle:(NSString *)entityTitle andFieldName:(NSString *)fieldName andOrderId:(NSUInteger)orderId {
    NSArray *valuesArray = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityTitle inManagedObjectContext:self.managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[FORMAT_STRING:@"(%@ = %lu)", fieldName, (unsigned long)orderId]]; //order_id
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedValues = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([fetchedValues count] > 0)
        valuesArray = fetchedValues;
    
    return valuesArray;
}
#pragma mark -


#pragma mark - Core Data stack
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil)
        return _managedObjectModel;

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PromUaNewTest" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PromUaNewTest.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil)
        return _managedObjectContext;

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
        return nil;

    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
#pragma mark - 

#pragma mark - Core Data Saving support
- (void)saveContext {
    if (self.managedObjectContext != nil) {
        NSError *error = nil;
        BOOL saveFlag = [self.managedObjectContext save:&error];
        
        if (!saveFlag)
            NSLog(@"City, couldn't save: %@", [error localizedDescription]);
        
        if ([self.managedObjectContext hasChanges] && !saveFlag) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark -

@end
