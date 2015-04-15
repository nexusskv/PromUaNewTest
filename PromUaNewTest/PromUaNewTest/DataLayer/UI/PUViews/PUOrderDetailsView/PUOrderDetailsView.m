//
//  PUOrderDetailsView.m
//  PromUaNewTest
//
//  Created by rost on 15.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUOrderDetailsView.h"
#import "PUDateFormatter.h"


@interface PUOrderDetailsView ()

@property (nonatomic, strong) UILabel *orderIdLbl;
@property (nonatomic, strong) UILabel *customerTitleLbl;
@property (nonatomic, strong) UILabel *dateLbl;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) UILabel *emailLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *companyLbl;          // VALUE FOR THIS LABEL ABSENT IN XML-FEED !!!!

@end


@implementation PUOrderDetailsView

#pragma mark - Constructor
- (instancetype)init
{
    self = [super init];
    if (self) {
        _orderIdLbl         = [self setLabelWithFrame:CGRectZero];
        _customerTitleLbl   = [self setLabelWithFrame:CGRectZero];
        _dateLbl            = [self setLabelWithFrame:CGRectZero];
        _phoneLbl           = [self setLabelWithFrame:CGRectZero];
        _emailLbl           = [self setLabelWithFrame:CGRectZero];
        _addressLbl         = [self setLabelWithFrame:CGRectZero];
        _companyLbl         = [self setLabelWithFrame:CGRectZero];
        
        [self addSubview:_orderIdLbl];
        [self addSubview:_customerTitleLbl];
        [self addSubview:_dateLbl];
        [self addSubview:_phoneLbl];
        [self addSubview:_emailLbl];
        [self addSubview:_addressLbl];
        [self addSubview:_companyLbl];
        
        NSDictionary *views = @{@"orderIdLbl"       : _orderIdLbl,
                                @"customerTitleLbl" : _customerTitleLbl,
                                @"dateLbl"          : _dateLbl,
                                @"phoneLbl"         : _phoneLbl,
                                @"emailLbl"         : _emailLbl,
                                @"addressLbl"       : _addressLbl,
                                @"companyLbl"       : _companyLbl};
        
        _orderIdLbl.translatesAutoresizingMaskIntoConstraints       = NO;
        _customerTitleLbl.translatesAutoresizingMaskIntoConstraints = NO;
        _dateLbl.translatesAutoresizingMaskIntoConstraints          = NO;
        _phoneLbl.translatesAutoresizingMaskIntoConstraints         = NO;
        _emailLbl.translatesAutoresizingMaskIntoConstraints         = NO;
        _addressLbl.translatesAutoresizingMaskIntoConstraints       = NO;
        _companyLbl.translatesAutoresizingMaskIntoConstraints       = NO;
        
        for (NSString *labelForTitle in views.allKeys) {
            NSString *formatStr = [FORMAT_STRING:@"H:|-(10)-[%@]-(10)-|", labelForTitle];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatStr
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
        }
        
        NSString *orderVerticalFormat = @"V:|-(10)-[orderIdLbl(18)]-[customerTitleLbl(18)]-[dateLbl(18)]-[phoneLbl(18)]-[emailLbl(18)]-[addressLbl(18)]-[companyLbl(18)]";
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:orderVerticalFormat
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
    }
    return self;
}
#pragma mark -


#pragma mark - Setter
- (void)setOrderInfo:(Orders *)orderInfo {
    if (![EMPTY_STRING:[orderInfo.orderId stringValue]])
        _orderIdLbl.text = [FORMAT_STRING:@"Номер заказа: %@", [orderInfo.orderId stringValue]];
    
    if (![EMPTY_STRING:orderInfo.name])
        _customerTitleLbl.text = [FORMAT_STRING:@"Заказчик: %@", orderInfo.name];
    
    if (![EMPTY_STRING:[orderInfo.date stringValue]]) {
        NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[orderInfo.date doubleValue]];
        _dateLbl.text = [FORMAT_STRING:@"Дата: %@", [PUDateFormatter setDate:orderDate  withFormat:@"dd.MM.yy HH:mm"]];
    }
    
    if (![EMPTY_STRING:orderInfo.phone])
        _phoneLbl.text  = [FORMAT_STRING:@"Телефон: %@", orderInfo.phone];
    
    if (![EMPTY_STRING:orderInfo.email])
        _emailLbl.text  = [FORMAT_STRING:@"Email: %@", orderInfo.email];
    
    if (![EMPTY_STRING:orderInfo.address])
        _addressLbl.text = [FORMAT_STRING:@"Адрес доставки: %@", orderInfo.address];
    
    if (![EMPTY_STRING:orderInfo.company])
        _companyLbl.text = orderInfo.company;
}
#pragma mark -


#pragma mark - setLabelWithFrame:
- (UILabel *)setLabelWithFrame:(CGRect)lblRect {
    UILabel *setLbl = [[UILabel alloc] initWithFrame:lblRect];
    
    setLbl.backgroundColor = [UIColor clearColor];
    setLbl.textColor       = [UIColor darkGrayColor];
    setLbl.font            = [UIFont fontWithName:@"Helvetica" size:16.0f];
    setLbl.textAlignment   = NSTextAlignmentLeft;
    setLbl.lineBreakMode   = NSLineBreakByWordWrapping;
    setLbl.numberOfLines   = 1;
    
    return setLbl;
}
#pragma mark -

@end
