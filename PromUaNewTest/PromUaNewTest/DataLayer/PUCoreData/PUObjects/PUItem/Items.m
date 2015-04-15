//
//  Items.m
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "Items.h"


@implementation Items

@dynamic currency;
@dynamic image;
@dynamic itemId;
@dynamic name;
@dynamic order_id;
@dynamic price;
@dynamic quantity;
@dynamic sku;
@dynamic url;

- (void)description {
    NSLog(@"ITEM ID->%d \t NAME->%@ BY_ORDER->%d", [self.itemId intValue], self.name, [self.order_id intValue]);
}

@end
