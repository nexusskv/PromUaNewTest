//
//  Orders.m
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "Orders.h"


@implementation Orders

@dynamic address;
@dynamic company;
@dynamic deliveryCost;
@dynamic deliveryType;
@dynamic email;
@dynamic index;
@dynamic name;
@dynamic orderId;
@dynamic payerComment;
@dynamic paymentType;
@dynamic phone;
@dynamic price;
@dynamic salesComment;
@dynamic date;
@dynamic state;

- (void)description {
    NSLog(@"ORDER ID->%d \t NAME->%@ BY_DATE->%@", [self.orderId intValue], self.name, self.date);
}

@end
