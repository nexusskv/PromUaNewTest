//
//  PUBuilderViewController.m
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUBuilderViewController.h"

@interface PUBuilderViewController ()

@end

@implementation PUBuilderViewController

#pragma mark - Constructor
- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
#pragma mark -

#pragma mark - setTableByRect:andSeparator:
- (UITableView *)setTableByRect:(CGRect)frame andSeparator:(BOOL)sepFlag {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];    
    tableView.backgroundColor   = [UIColor clearColor];
    
    if (sepFlag) {
        tableView.separatorStyle    = UITableViewCellSeparatorStyleSingleLine;
        
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
            [tableView setSeparatorInset:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f)];
    } else
        tableView.separatorStyle    = UITableViewCellSeparatorStyleNone;
    
    return tableView;
}
#pragma mark -

#pragma mark - setSearchBarFromRect:andHolder:
- (UISearchBar *)setSearchBarFromRect:(CGRect)searchRect andHolder:(NSString *)searchHolder {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:searchRect];
    searchBar.searchBarStyle    = UISearchBarStyleMinimal;
    searchBar.backgroundColor   = [UIColor whiteColor];
    
    searchBar.translucent           = YES;
    searchBar.placeholder           = searchHolder;
    searchBar.showsCancelButton     = YES;
    searchBar.layer.cornerRadius    = 5.0f;
    searchBar.clipsToBounds         = YES;
    
    return searchBar;
}
#pragma mark -

#pragma mark - showAlert:withMessage:
- (void)showAlert:(NSString *)titleStr withMessage:(NSString *)msgStr {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr
                                                    message:msgStr
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
