//
//  PUItemCell.m
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUItemCell.h"


@interface PUItemCell ()

@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *itemTitleLbl;
@property (nonatomic, strong) UILabel *itemDetailsLbl;
@property (nonatomic, strong) UILabel *itemTotalLbl;

@end


@implementation PUItemCell

#pragma mark - Constructor
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            _itemImageView  = [self setImageFromRect:CGRectZero];
            _itemTitleLbl   = [self setLabelWithFrame:CGRectZero];
            _itemDetailsLbl = [self setLabelWithFrame:CGRectZero];
            _itemTotalLbl   = [self setLabelWithFrame:CGRectZero];
            _itemTotalLbl.font = [UIFont boldSystemFontOfSize:19.0f];
            
            [self addSubview:_itemImageView];
            [self addSubview:_itemTitleLbl];
            [self addSubview:_itemDetailsLbl];
            [self addSubview:_itemTotalLbl];
            
            NSDictionary *views = @{@"itemImageView"    : _itemImageView,
                                    @"itemTitleLbl"     : _itemTitleLbl,
                                    @"itemDetailsLbl"   : _itemDetailsLbl,
                                    @"itemTotalLbl"     : _itemTotalLbl};
            
            _itemImageView.translatesAutoresizingMaskIntoConstraints    = NO;
            _itemTitleLbl.translatesAutoresizingMaskIntoConstraints     = NO;
            _itemDetailsLbl.translatesAutoresizingMaskIntoConstraints   = NO;
            _itemTotalLbl.translatesAutoresizingMaskIntoConstraints     = NO;
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[itemImageView(70)]-(10)-[itemTitleLbl]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[itemImageView(70)]-(10)-[itemDetailsLbl]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[itemImageView(70)]-(10)-[itemTotalLbl]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[itemImageView(70)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[itemTitleLbl(18)]-[itemDetailsLbl(18)]-(5)-[itemTotalLbl(22)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
    }
    return self;
}
#pragma mark -


#pragma mark - Setters
- (void)setItemInfo:(Items *)itemInfo {
    
    if (![EMPTY_STRING:itemInfo.image]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:itemInfo.image]];
            dispatch_async(dispatch_get_main_queue(), ^{
                 _itemImageView.image = [UIImage imageWithData:imageData];
            });
        });
    }
    
    if (![EMPTY_STRING:itemInfo.name])
        _itemTitleLbl.text   = itemInfo.name;

    if ((![EMPTY_STRING:[itemInfo.price stringValue]]) && (![EMPTY_STRING:[itemInfo.quantity stringValue]]))
        _itemDetailsLbl.text = [FORMAT_STRING:@"%@ грн | %d шт ", [itemInfo.price stringValue], [itemInfo.quantity intValue]];

    if ((![EMPTY_STRING:[itemInfo.price stringValue]]) && (![EMPTY_STRING:[itemInfo.quantity stringValue]]))
        _itemTotalLbl.text = [FORMAT_STRING:@"%d грн", ([itemInfo.price intValue] * [itemInfo.quantity intValue])];
}
#pragma mark -

@end
