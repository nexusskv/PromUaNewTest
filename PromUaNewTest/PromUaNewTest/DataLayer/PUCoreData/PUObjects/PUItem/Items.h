//
//  Items.h
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Items : NSManagedObject

@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order_id;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * sku;
@property (nonatomic, retain) NSString * url;

- (void)description;

@end
