//
//  PUConstants.h
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#ifndef PromUaNewTest_PUConstants_h
#define PromUaNewTest_PUConstants_h

// SET VIEW BOUNDS MACROSES
#define VIEW_WIDTH          self.view.bounds.size.width
#define VIEW_HEIGHT         self.view.bounds.size.height

// SET MACROSES FOR STRINGS
#define FORMAT_STRING       NSString stringWithFormat
#define EMPTY_STRING        PUConstants isEmptyString

// TABLEVIEW CELLS ID'S
#define ORDERS_CELL_ID      @"OrderId"
#define ITEMS_CELL_ID       @"ItemId"


#endif


extern NSString *const ordersUrl;

extern NSString *const kOrderKey;
extern NSString *const kItemKey;

extern NSString *const kOrdersEntity;
extern NSString *const kItemsEntity;


@interface PUConstants : NSObject

+ (BOOL)isEmptyString:(NSString *)checkString;

@end