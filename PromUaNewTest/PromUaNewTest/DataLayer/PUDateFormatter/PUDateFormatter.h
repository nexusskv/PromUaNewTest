//
//  PUDateFormatter.h
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUDateFormatter : NSObject

+ (NSString *)setDate:(NSDate *)incVal withFormat:(NSString *)formatStr;
+ (double)convertDateToDoubleFromString:(NSString *)dateStr;

@end
