//
//  PUOrderCell.h
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUBuilderCell.h"


@interface PUOrderCell : PUBuilderCell

- (void)setGeneralInfo:(NSString *)generalInfo;
- (void)setDescription:(NSString *)description;
- (void)setTime:(NSString *)time;

@end
