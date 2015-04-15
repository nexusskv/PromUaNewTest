//
//  PUOrderCell.m
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUOrderCell.h"


@interface PUOrderCell ()

@property (nonatomic, strong) UILabel *generalInfoLbl;
@property (nonatomic, strong) UILabel *descriptionLbl;
@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation PUOrderCell

#pragma mark - Constructor
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _generalInfoLbl = [self setLabelWithFrame:CGRectZero];
        _descriptionLbl = [self setLabelWithFrame:CGRectZero];
        _timeLbl        = [self setLabelWithFrame:CGRectZero];
        
        [self addSubview:_generalInfoLbl];
        [self addSubview:_descriptionLbl];
        [self addSubview:_timeLbl];
        
        _generalInfoLbl.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLbl.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLbl.translatesAutoresizingMaskIntoConstraints        = NO;
        
        NSDictionary *views = @{@"generalLbl"  : _generalInfoLbl,
                                @"descriptLbl" : _descriptionLbl,
                                @"timeLbl"     : _timeLbl};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[generalLbl]-(70)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[descriptLbl]-(70)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[generalLbl(18)]-[descriptLbl(18)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[timeLbl]-(10)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[timeLbl(20)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
    }
    return self;
}
#pragma mark -


#pragma mark - Setters
- (void)setGeneralInfo:(NSString *)generalInfo {
    _generalInfoLbl.text = generalInfo;
}

- (void)setDescription:(NSString *)description {
    _descriptionLbl.text = description;
}

- (void)setTime:(NSString *)time {
    _timeLbl.text = time;
}
#pragma mark -

@end
