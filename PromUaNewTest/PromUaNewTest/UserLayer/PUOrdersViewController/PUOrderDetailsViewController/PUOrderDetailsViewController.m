//
//  PUOrderDetailsViewController.m
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUOrderDetailsViewController.h"
#import "PUItemCell.h"
#import "PUOrderDetailsView.h"


@interface PUOrderDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *detailsTable;
@end


@implementation PUOrderDetailsViewController

#pragma mark - View life cycle
- (void)loadView {
    [super loadView];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self createUI];
}
#pragma mark -


#pragma mark - createUI
- (void)createUI {
    
    // ADD ORDERS TABLE
    _detailsTable = [self setTableByRect:CGRectZero andSeparator:YES];
    _detailsTable.delegate    = self;
    _detailsTable.dataSource  = self;
    [self.view addSubview:_detailsTable];
    [_detailsTable registerClass:[PUItemCell class] forCellReuseIdentifier:ORDERS_CELL_ID];
    [_detailsTable registerClass:[PUItemCell class] forCellReuseIdentifier:ITEMS_CELL_ID];
    
    NSDictionary *views = @{@"table" : _detailsTable};
    
    _detailsTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(1)-[table]-(1)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(3)-[table]-(3)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedViewSelector:)];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionRight];
    [_detailsTable addGestureRecognizer:swipeGR];
    
    swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedViewSelector:)];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_detailsTable addGestureRecognizer:swipeGR];
}
#pragma mark -


#pragma mark - swipedViewSelector:
- (void)swipedViewSelector:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            _selectedIndex--;
            if (_selectedIndex >= 0) {
                [self setDataSourceByIndex:_selectedIndex];
            } else {
                [self showAlert:@"Сообщение!" withMessage:@"Предыдущих заказов больше нет."];
                _selectedIndex = 0;
            }
        } else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
            _selectedIndex++;
            if (_selectedIndex < [_sourceArr count]) {
                [self setDataSourceByIndex:_selectedIndex];
            } else {
                [self showAlert:@"Сообщение!" withMessage:@"Следующих заказов больше нет."];
                _selectedIndex = [_sourceArr count] - 1;
            }
        }
    }
}
#pragma mark -


#pragma mark - setDataSourceByIndex:
- (void)setDataSourceByIndex:(NSInteger)index {
    Orders *previousOrder   = _sourceArr[index][kOrderKey];
    NSArray *allItemsArr = [[PUDataFetcher shared] fetchObjectsByTitle:kItemsEntity
                                                          andFieldName:@"order_id"
                                                            andOrderId:[previousOrder.orderId intValue]];

    _dataDic = nil;
    _dataDic = @{kOrderKey : previousOrder,
                 kItemKey  : allItemsArr};
    [_detailsTable reloadData];
}
#pragma mark -


#pragma mark - TableView Delegate & DataSourse Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataDic[kItemKey] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Items *item = _dataDic[kItemKey][indexPath.row];
    [(PUItemCell *)cell setItemInfo:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemCellId  = ITEMS_CELL_ID;

    PUItemCell *cell = (PUItemCell *)[tableView dequeueReusableCellWithIdentifier:itemCellId forIndexPath:indexPath];
    if (cell == nil)
        cell = [[PUItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellId];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 180.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PUOrderDetailsView *headerView = [[PUOrderDetailsView alloc] init];
    
    Orders *order = _dataDic[kOrderKey];
    [headerView setOrderInfo:order];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, VIEW_WIDTH, 40.0f)];
    footerView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *footerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, VIEW_WIDTH, 30.0f)];
    footerTitleLbl.textAlignment = NSTextAlignmentCenter;
    footerTitleLbl.font = [UIFont boldSystemFontOfSize:28.0f];
    
    Orders *order = _dataDic[kOrderKey];
    footerTitleLbl.text = [FORMAT_STRING:@"%d грн", [order.price intValue]];
    [footerView addSubview:footerTitleLbl];
    
    return footerView;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
