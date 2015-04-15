//
//  PUDataFetcher.h
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUDataFetcher : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)shared;

- (NSArray *)fetchObjectsByTitle:(NSString *)entityTitle;
- (NSArray *)fetchObjectsByTitle:(NSString *)entityTitle andFieldName:(NSString *)fieldName andOrderId:(NSUInteger)orderId;
- (void)saveContext;
@end
