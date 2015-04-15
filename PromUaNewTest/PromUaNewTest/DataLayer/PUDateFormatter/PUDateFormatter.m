//
//  PUDateFormatter.m
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUDateFormatter.h"

@implementation PUDateFormatter

#pragma mark - setDate:withFormat:
+ (NSString *)setDate:(NSDate *)incVal withFormat:(NSString *)formatStr {
    if ((incVal) && (![EMPTY_STRING:formatStr])) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"dd.MM.yy HH:mm"];
        //NSDate *startDate =	[outputFormatter dateFromString:incVal];
        [outputFormatter setDateFormat:formatStr];
        NSString *resultStr = [outputFormatter stringFromDate:incVal];
            return resultStr;
    }
    return nil;
}
#pragma mark -

#pragma mark - convertDateToDoubleFromString:
+ (double)convertDateToDoubleFromString:(NSString *)dateStr {
    if (![EMPTY_STRING:dateStr]) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"dd.MM.yy HH:mm"];
        NSDate *convertDate = [outputFormatter dateFromString:dateStr];
        
        return [convertDate timeIntervalSince1970];
    }
    return 0.0;
}
#pragma mark -

@end
