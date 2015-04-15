//
//  PUBuilderCell.m
//  PromUaNewTest
//
//  Created by rost on 14.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUBuilderCell.h"

@implementation PUBuilderCell

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

#pragma mark - setImageFromRect:
- (UIImageView *)setImageFromRect:(CGRect)imgRect {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgRect];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    return imgView;
}
#pragma mark -

@end
