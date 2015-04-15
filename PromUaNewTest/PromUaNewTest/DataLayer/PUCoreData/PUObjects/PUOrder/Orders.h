//
//  Orders.h
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Orders : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSNumber * deliveryCost;
@property (nonatomic, retain) NSString * deliveryType;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic, retain) NSString * payerComment;
@property (nonatomic, retain) NSString * paymentType;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * salesComment;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * state;

- (void)description;

@end
