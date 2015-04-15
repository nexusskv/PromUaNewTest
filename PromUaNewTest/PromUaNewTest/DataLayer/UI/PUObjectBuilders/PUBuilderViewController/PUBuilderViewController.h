//
//  PUBuilderViewController.h
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUBuilderViewController : UIViewController

- (UITableView *)setTableByRect:(CGRect)frame andSeparator:(BOOL)sepFlag;

- (UISearchBar *)setSearchBarFromRect:(CGRect)searchRect andHolder:(NSString *)searchHolder;

- (void)showAlert:(NSString *)titleStr withMessage:(NSString *)msgStr;

@end
