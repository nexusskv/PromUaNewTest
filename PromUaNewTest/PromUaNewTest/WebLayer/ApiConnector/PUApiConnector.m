//
//  PUApiConnector.m
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUApiConnector.h"
#import "TBXML+HTTP.h"
#import "PUDateFormatter.h"


@implementation PUApiConnector

#pragma mark - loadOrders
- (void)loadOrders {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{        
        TBXMLSuccessBlock successBlock = ^(TBXML *tbxml) {
            if (tbxml.rootXMLElement) {
                [self traverseElement:tbxml.rootXMLElement];        // PARSE DOWNLOADED XML
                [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayUpdated" object:@YES];  // SEND SUCCESS NOTIFICATION
            }
        };
        
        TBXMLFailureBlock errorBlock = ^(TBXML *tbxml, NSError *error) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayUpdated" object:error.description];   // SEND ERROR NOTIFICATION
            
        };
        
        [TBXML newTBXMLWithURL:[NSURL URLWithString:ordersUrl]
                       success:successBlock
                       failure:errorBlock];   // ASYNC DOWNLOAD XML
    });
}
#pragma mark -


#pragma mark - traverseElement:
- (void)traverseElement:(TBXMLElement *)element {
    do {
        if (element->firstChild) {
        
        if ([[TBXML elementName:element] isEqualToString:@"order"]) {
            
            if (element->firstAttribute != NULL) {
                NSString *orderIdStr = [FORMAT_STRING:@"%s", element->firstAttribute->value];   // CHECK EXISTS ORDERS
                NSUInteger orderId = [orderIdStr intValue];
                
                NSArray *existOrdersArr = [[PUDataFetcher shared] fetchObjectsByTitle:kOrdersEntity
                                                                         andFieldName:@"orderId"
                                                                           andOrderId:orderId];
                
                if ((!existOrdersArr) || ([existOrdersArr count] == 0)) {
                    NSEntityDescription *ordersEntity = [NSEntityDescription entityForName:kOrdersEntity
                                                                    inManagedObjectContext:[PUDataFetcher shared].managedObjectContext];
                    Orders *newOrder = [[Orders alloc] initWithEntity:ordersEntity
                                       insertIntoManagedObjectContext:[PUDataFetcher shared].managedObjectContext];
                    
                    newOrder.orderId = @(orderId);
                    
                    if (element->firstAttribute->next != NULL)
                        newOrder.state = [FORMAT_STRING:@"%s", element->firstAttribute->next->value];

                    
                    if ([TBXML childElementNamed:@"name" parentElement:element])
                        if ([TBXML childElementNamed:@"name" parentElement:element]->text != NULL)
                            newOrder.name = [NSString stringWithUTF8String:[TBXML childElementNamed:@"name" parentElement:element]->text];
                    
                    if ([TBXML childElementNamed:@"phone" parentElement:element])
                        if ([TBXML childElementNamed:@"phone" parentElement:element]->text != NULL)
                            newOrder.phone = [NSString stringWithUTF8String:[TBXML childElementNamed:@"phone" parentElement:element]->text];
                    
                    if ([TBXML childElementNamed:@"email" parentElement:element])
                        if ([TBXML childElementNamed:@"email" parentElement:element]->text != NULL)
                            newOrder.email = [NSString stringWithUTF8String:[TBXML childElementNamed:@"email" parentElement:element]->text];
                    
                    if ([TBXML childElementNamed:@"date" parentElement:element])
                        if ([TBXML childElementNamed:@"date" parentElement:element]->text != NULL) {
                            NSString *dateStr = [NSString stringWithUTF8String:[TBXML childElementNamed:@"date" parentElement:element]->text];
                            newOrder.date = @([PUDateFormatter convertDateToDoubleFromString:dateStr]);
                        }
                    
                    if ([TBXML childElementNamed:@"address" parentElement:element])
                        if ([TBXML childElementNamed:@"address" parentElement:element]->text != NULL)
                            newOrder.address = [NSString stringWithUTF8String:[TBXML childElementNamed:@"address" parentElement:element]->text];
                    
                    if ([TBXML childElementNamed:@"index" parentElement:element])
                        if ([TBXML childElementNamed:@"index" parentElement:element]->text != NULL) {
                            NSString *indexStr = [NSString stringWithUTF8String:[TBXML childElementNamed:@"index" parentElement:element]->text];
                            newOrder.index = @([indexStr intValue]);
                        }
                    
                    if ([TBXML childElementNamed:@"paymentType" parentElement:element])
                        if ([TBXML childElementNamed:@"paymentType" parentElement:element]->text != NULL)
                            newOrder.paymentType = [NSString stringWithUTF8String:[TBXML childElementNamed:@"paymentType" parentElement:element]->text];
                    
                    if ([TBXML childElementNamed:@"deliveryType" parentElement:element])
                        if ([TBXML childElementNamed:@"deliveryType" parentElement:element]->text != NULL)
                            newOrder.deliveryType = [NSString stringWithUTF8String:[TBXML childElementNamed:@"deliveryType" parentElement:element]->text];
                    
                    if ([TBXML childElementNamed:@"payercomment" parentElement:element])
                        if ([TBXML childElementNamed:@"payercomment" parentElement:element]->text != NULL)
                            newOrder.payerComment = [NSString stringWithUTF8String:[TBXML childElementNamed:@"payercomment" parentElement:element]->text];
                    
                    if ([TBXML childElementNamed:@"priceUAH" parentElement:element])
                        if ([TBXML childElementNamed:@"priceUAH" parentElement:element]->text != NULL) {
                            NSString *priceStr = [NSString stringWithUTF8String:[TBXML childElementNamed:@"priceUAH" parentElement:element]->text];
                            newOrder.price = @([priceStr intValue]);
                        }
                    
                    
                    if ([TBXML childElementNamed:@"items" parentElement:element]) {
                        
                        TBXMLElement *allXmlItems = [TBXML childElementNamed:@"items" parentElement:element];
                        TBXMLElement *xmlItem = [TBXML childElementNamed:@"item" parentElement:allXmlItems];
                        while (xmlItem) {
                            NSEntityDescription *itemEntity = [NSEntityDescription entityForName:kItemsEntity
                                                                          inManagedObjectContext:[PUDataFetcher shared].managedObjectContext];
                            Items *newItem = [[Items alloc] initWithEntity:itemEntity
                                            insertIntoManagedObjectContext:[PUDataFetcher shared].managedObjectContext];
                            
                            if (xmlItem->firstAttribute->value != NULL) {
                                NSString *itemIdStr = [FORMAT_STRING:@"%s", xmlItem->firstAttribute->value];
                                newItem.itemId = @([itemIdStr intValue]);
                            }
                            
                            
                            NSString *orderIdStr = [FORMAT_STRING:@"%s", element->firstAttribute->value];
                            newItem.order_id = @([orderIdStr intValue]);            // SAVE ORDER_ID TO EVERY CHILD_ITEM FOR NEXT SELECTION
                            
                            if ([TBXML childElementNamed:@"name" parentElement:xmlItem])
                                if ([TBXML childElementNamed:@"name" parentElement:xmlItem]->text != NULL)
                                    newItem.name = [NSString stringWithUTF8String:[TBXML childElementNamed:@"name" parentElement:xmlItem]->text];
                            
                            if ([TBXML childElementNamed:@"quantity" parentElement:xmlItem])
                                if ([TBXML childElementNamed:@"quantity" parentElement:xmlItem]->text != NULL) {
                                    NSString *quantityStr = [NSString stringWithUTF8String:[TBXML childElementNamed:@"quantity" parentElement:xmlItem]->text];
                                    newItem.quantity = @([quantityStr intValue]);
                                }
                            
                            if ([TBXML childElementNamed:@"currency" parentElement:xmlItem])
                                if ([TBXML childElementNamed:@"currency" parentElement:xmlItem]->text != NULL)
                                    newItem.currency = [NSString stringWithUTF8String:[TBXML childElementNamed:@"currency" parentElement:xmlItem]->text];
                            
                            if ([TBXML childElementNamed:@"image" parentElement:xmlItem])
                                if ([TBXML childElementNamed:@"image" parentElement:xmlItem]->text != NULL)
                                    newItem.image = [NSString stringWithUTF8String:[TBXML childElementNamed:@"image" parentElement:xmlItem]->text];
                            
                            if ([TBXML childElementNamed:@"url" parentElement:xmlItem])
                                if ([TBXML childElementNamed:@"url" parentElement:xmlItem]->text != NULL)
                                    newItem.url = [NSString stringWithUTF8String:[TBXML childElementNamed:@"url" parentElement:xmlItem]->text];
                            
                            if ([TBXML childElementNamed:@"price" parentElement:xmlItem])
                                if ([TBXML childElementNamed:@"price" parentElement:xmlItem]->text != NULL) {
                                    NSString *priceStr = [NSString stringWithUTF8String:[TBXML childElementNamed:@"price" parentElement:xmlItem]->text];
                                    newItem.price = @([priceStr intValue]);
                                }
                            
                            if ([TBXML childElementNamed:@"sku" parentElement:xmlItem])
                                if ([TBXML childElementNamed:@"sku" parentElement:xmlItem]->text != NULL) {
                                    NSString *skuStr = [NSString stringWithUTF8String:[TBXML childElementNamed:@"sku" parentElement:xmlItem]->text];
                                    newItem.sku = @([skuStr intValue]);
                                }
                            
                            xmlItem = [TBXML nextSiblingNamed:@"item" searchFromElement:xmlItem];
                        }
                    }
                }
            }
        } else
            [self traverseElement:element->firstChild];
        }
    } while ((element = element->nextSibling));
    
    [[PUDataFetcher shared] saveContext];
}
#pragma mark -

@end
