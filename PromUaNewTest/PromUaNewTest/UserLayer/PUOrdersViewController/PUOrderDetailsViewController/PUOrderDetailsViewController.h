//
//  PUOrderDetailsViewController.h
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUOrderDetailsViewController : PUBuilderViewController

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
