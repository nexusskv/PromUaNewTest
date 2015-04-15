//
//  PUOrdersViewController.m
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUOrdersViewController.h"
#import "PUApiConnector.h"
#import "PUOrderCell.h"
#import "PUDateFormatter.h"
#import "PUOrderDetailsViewController.h"


@interface PUOrdersViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *ordersTable;
@property (nonatomic, strong) NSArray *ordersArr;
@property (nonatomic, strong) NSMutableArray *ordersCopyMutArr;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end


@implementation PUOrdersViewController

#pragma mark - View life cycle
- (void)loadView {
    [super loadView];
    
    self.title = @"Заказы";
    
    [self createUI];
    
    _isSearching = NO;
    
    [self setDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"arrayUpdated" object:nil];
}
#pragma mark -


#pragma mark - createUI
- (void)createUI {
    // ADD SEARCH BAR
    UISearchBar *searchBar = [self setSearchBarFromRect:CGRectZero andHolder:@"Поиск"];
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    searchBar.delegate       = self;
    [self.view addSubview:searchBar];
  
    // ADD ORDERS TABLE
    _ordersTable = [self setTableByRect:CGRectZero andSeparator:YES];
    _ordersTable.delegate    = self;
    _ordersTable.dataSource  = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Обновляю данные!"];
    [_refreshControl addTarget:self action:@selector(refreshControlSelector:) forControlEvents:UIControlEventValueChanged];
    [_ordersTable addSubview:_refreshControl];
    
    [self.view addSubview:_ordersTable];
    
    [_ordersTable registerClass:[PUOrderCell class] forCellReuseIdentifier:ORDERS_CELL_ID];
    
    NSDictionary *views = @{@"searchBar" : searchBar,
                            @"table"     : _ordersTable};
    
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBar(40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    _ordersTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(1)-[table]-(1)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[table]-(3)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}
#pragma mark -


#pragma mark - refreshOrders
- (void)refreshOrders {
    // LOADING ORDERS FROM SERVER API
    PUApiConnector *apiConnector   = [[PUApiConnector alloc] init];
    [apiConnector loadOrders];
}
#pragma mark -


#pragma mark - refreshControl
- (void)refreshControlSelector:(id)sender {
    [self refreshOrders];
}
#pragma mark -


#pragma mark - setDataSource
- (void)setDataSource {
    if ([[[PUDataFetcher shared] fetchObjectsByTitle:kOrdersEntity] count] > 0) {
        _ordersArr = [[PUDataFetcher shared] fetchObjectsByTitle:kOrdersEntity];
        
        _ordersArr = [_ordersArr sortedArrayUsingComparator:^NSComparisonResult(Orders *p1, Orders *p2){
            return [p2.date compare:p1.date];
        }];
        
        NSMutableArray *ordersMutArr = [NSMutableArray array];
        NSArray *itemsArr = nil;
        
        for (Orders *order in _ordersArr) {
            if (order.orderId) {
                itemsArr = [[PUDataFetcher shared] fetchObjectsByTitle:kItemsEntity
                                                          andFieldName:@"order_id"
                                                            andOrderId:[order.orderId intValue]];
                
                for (Items *item in itemsArr) {
                    if (item) {
                        [ordersMutArr addObject:@{kOrderKey : order,
                                                  kItemKey  : item}];
                    }
                }
            }
        }
        
        if ([ordersMutArr count] > 0) {
            _ordersArr = nil;
            _ordersArr = ordersMutArr;
            
            _ordersCopyMutArr = [NSMutableArray arrayWithArray:_ordersArr];  // SET BACKUP OF DATA_SOURCE FOR WORK CANCEL OF FILTERING
            [_ordersTable reloadData];
        }
    }
    else
        [self refreshOrders];
}
#pragma mark -


#pragma mark - updateTable:
- (void)updateTable:(NSNotification *)receivedNotif {
    if ([receivedNotif.object isKindOfClass:[NSNumber class]])      // CHECK RECIEVED NOTIFICATION
        [self setDataSource];
    else
        if ([receivedNotif.object isKindOfClass:[NSString class]])  // CHECK RECIEVED NOTIFICATION FOR ERROR
            [self showAlert:@"Ошибка" withMessage:(NSString *)receivedNotif.object]; // SHOW ERROR AS ALERT
    
    [self.refreshControl endRefreshing];
}
#pragma mark -


#pragma mark - TableView Delegate & DataSourse Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ordersArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Orders *order = _ordersArr[indexPath.row][kOrderKey];
    Items *item = _ordersArr[indexPath.row][kItemKey];
    
    [(PUOrderCell *)cell setGeneralInfo:[FORMAT_STRING:@"%@ - %@", order.orderId, order.name]];
    
    [(PUOrderCell *)cell setDescription:[FORMAT_STRING:@"%@ %@ - %@", item.price, item.currency, item.name]];
    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[order.date doubleValue]];
    [(PUOrderCell *)cell setTime:[PUDateFormatter setDate:orderDate  withFormat:@"HH:mm"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *orderCellId = ORDERS_CELL_ID;
    
    PUOrderCell *cell = (PUOrderCell *)[tableView dequeueReusableCellWithIdentifier:orderCellId forIndexPath:indexPath];    
    if (cell == nil)
        cell = [[PUOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellId];

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Orders *selectedOrder   = _ordersArr[indexPath.row][kOrderKey];
    
    NSArray *allOrdersArr = [[PUDataFetcher shared] fetchObjectsByTitle:kOrdersEntity];
    allOrdersArr = [allOrdersArr sortedArrayUsingComparator:^NSComparisonResult(Orders *p1, Orders *p2){
        return [p2.date compare:p1.date];
    }];
    
    PUOrderDetailsViewController *orderDetaisVC = [[PUOrderDetailsViewController alloc] init];
    
    NSMutableArray *ordersMutArr = [NSMutableArray array];
    NSDictionary *selectedDataDic = nil;
    NSUInteger selectedIndex = 0;
    int count = 0;
    for (Orders *order in allOrdersArr) {
        
        count++;
        
        if (order.orderId) {
            NSArray *itemsArr = [[PUDataFetcher shared] fetchObjectsByTitle:kItemsEntity
                                                               andFieldName:@"order_id"
                                                                 andOrderId:[order.orderId intValue]];

            if ([itemsArr count] > 0) {
                [ordersMutArr addObject:@{kOrderKey : order,
                                          kItemKey  : itemsArr}];
            }
            
            if ([order.orderId intValue] == [selectedOrder.orderId intValue]) {
                selectedIndex = count;
                selectedDataDic = @{kOrderKey : selectedOrder,
                                    kItemKey  : itemsArr};
            }
        }
    }
    
    
    orderDetaisVC.dataDic = selectedDataDic;
    orderDetaisVC.selectedIndex = selectedIndex;
    orderDetaisVC.sourceArr = ordersMutArr;
    [self.navigationController pushViewController:orderDetaisVC animated:YES];
}
#pragma mark -


#pragma mark - SearchBar Delegate methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if ([searchBar isFirstResponder])
        [searchBar resignFirstResponder];               // HIDE KEYBOARD
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ((searchText.length > 2) && (!_isSearching)) {    // SET CONDITION FOR START SEARCH
        self.isSearching = YES;                         // SET FLAG FOR SEARCH PROCESS SENTINEL
        [self filterByWord:searchText];                 // CALL SEARCH METHOD BY INPUT STRING
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self restoreData];                                 // RESTORE START DATA
    if ([searchBar isFirstResponder])
        [searchBar resignFirstResponder];               // HIDE KEYBOARD
    searchBar.text = @"";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];                   // HIDE KEYBOARD
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
#pragma mark -

#pragma mark - filterByWord:
- (void)filterByWord:(NSString *)wordFilter {
    __block NSMutableArray *filteredMutArr = [[NSMutableArray alloc] init];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("OrdersSort", NULL);  // CREATE CUSTOM QUEUE
    dispatch_async(fetchQ, ^{
        if ([filteredMutArr count] == 0) {           // CHECK FOR DUPLICATE CONDITION
            for (NSDictionary *order in _ordersArr) {   // SEARCH BY ORDER ID
                Orders *foundOrder = order[kOrderKey];
                NSRange compareRange = [[foundOrder.orderId stringValue] rangeOfString:wordFilter
                                                                               options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
                if(compareRange.location != NSNotFound)
                    [filteredMutArr addObject:order];
            }
        }
    });
    
    dispatch_async(fetchQ, ^{
        if ([filteredMutArr count] == 0) {           // CHECK FOR DUPLICATE CONDITION
            for (NSDictionary *order in _ordersArr) {   // SEARCH BY CUSTOMER NAME
                Orders *foundOrder = order[kOrderKey];
                NSRange compareRange = [foundOrder.name rangeOfString:wordFilter
                                                              options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
                if (compareRange.location != NSNotFound)
                    [filteredMutArr addObject:order];
            }
        }
    });
    
    dispatch_async(fetchQ, ^{
        if ([filteredMutArr count] == 0) {           // CHECK FOR DUPLICATE CONDITION
            for (NSDictionary *order in _ordersArr) {   // SEARCH BY PHONE
                Orders *foundOrder = order[kOrderKey];
                NSRange compareRange = [foundOrder.phone rangeOfString:wordFilter
                                                               options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
                if (compareRange.location != NSNotFound)
                    [filteredMutArr addObject:order];
            }
        }
    });
    
    dispatch_async(fetchQ, ^{
        if ([filteredMutArr count] == 0) {           // CHECK FOR DUPLICATE CONDITION
            for (NSDictionary *order in _ordersArr) {   // SEARCH BY SKU
                Items *foundItem = order[kItemKey];
                NSRange compareRange = [[foundItem.sku stringValue] rangeOfString:wordFilter
                                                                          options:(NSLiteralSearch|NSDiacriticInsensitiveSearch)];
                if (compareRange.location != NSNotFound)
                    [filteredMutArr addObject:order];
            }
        }
    });
    
    dispatch_async(fetchQ, ^{
        if ([filteredMutArr count] == 0) {           // CHECK FOR DUPLICATE CONDITION
            for (NSDictionary *order in self.ordersArr) {   // SEARCH BY TITLE OF ITEM
                Items *foundItem = order[kItemKey];
                NSRange compareRange = [foundItem.name rangeOfString:wordFilter
                                                             options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
                if (compareRange.location != NSNotFound)
                    [filteredMutArr addObject:order];
            }
        }
    });
    
    
    dispatch_async(fetchQ, ^{
        if ([filteredMutArr count] > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _ordersArr = nil;
                _ordersArr = filteredMutArr;    // SET FILTERED DATA_SOURCE TO GENERAL DATA_SOURCE
                
                [_ordersTable reloadData];     // ASYNC REFRESH TABLE
            });
        }
        _isSearching = NO;          // SET DISABLE FLAG FOR SEARCH PROCESS SENTINEL
    });
    
}
#pragma mark -


#pragma mark - restoreData
- (void)restoreData {
    _ordersArr = nil;
    _ordersArr = _ordersCopyMutArr;          // RESTORE DATA
    
    [_ordersTable reloadData];
}
#pragma mark -


#pragma mark - Destructor
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
