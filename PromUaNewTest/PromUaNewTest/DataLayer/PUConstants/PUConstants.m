//
//  PUConstants.m
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUConstants.h"


// SERVER API URL
NSString *const ordersUrl = @"https://my.prom.ua/cabinet/export_orders/xml/306906?hash_tag=e1177d00a4ec9b6388c57ce8e85df009";

// SET DICTIONARY KEYS
NSString *const kOrderKey =  @"order";
NSString *const kItemKey  =  @"item";

// COREDATA ENTITY TITLES
NSString *const kOrdersEntity =  @"Orders";
NSString *const kItemsEntity  =  @"Items";

@implementation PUConstants

+ (BOOL)isEmptyString:(NSString *)checkString {
    BOOL resultFlag = NO;
    
    if ((checkString == nil) ||
        ([checkString isMemberOfClass:[NSNull class]]) ||
        ([checkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0))
        resultFlag = YES;
    
    return resultFlag;
}

@end