//
//  BLCustomCell.m
//  BLTableViewDemo
//
//  Created by 松 段 on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BLCustomCell.h"
#import "BLCellButton.h"
#import "BLMessage.h"

@interface BLCustomCell()
{
    CGFloat _cellWidth;
}

@end

@implementation BLCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellWidth = [UIScreen mainScreen].bounds.size.width;
        
        self.headButton = [[BLCellButton alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        self.headButton.backgroundColor = [UIColor clearColor];
        [self.headButton addTarget:self
                        action:@selector(headButtonClicked:) 
              forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.headButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, _cellWidth - 70, 22)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blueColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_messageLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)headButtonClicked:(BLCellButton *)cellButton {
    if (_delegate && [(NSObject *)_delegate respondsToSelector:@selector(headButtonClicked:)]) {
        [_delegate headButtonClicked:cellButton];
    }
}

- (void)cleanComponents {
    [_headButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_headButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    _nameLabel.text = nil;
    _messageLabel.text = nil;
    _dateLabel.text = nil;
}

- (void)setComponentsWithMessage:(BLMessage *)aMessage indexPath:(NSIndexPath *)indexPath {
    _headButton.cellSection = indexPath.section;
    _headButton.cellRow = indexPath.row;

    [self cleanComponents];
    [self setName:aMessage.sender.name];
    [self setMessage:aMessage.text];
    [self setDate:aMessage.sendDate];
}

- (void)setName:(NSString *)aName {
    _nameLabel.text = aName;
}

- (void)setMessage:(NSString *)aText {
    CGFloat textWidth = _cellWidth - 70;
    
    CGSize textSize = [aText boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], }
                                               context:nil].size;
    _messageLabel.frame = CGRectMake(60, 32, textSize.width, textSize.height);
    _messageLabel.text = aText;
}

- (void)setDate:(NSDate *)aDate {
    CGFloat textWidth = _cellWidth - 70;

    CGFloat originY = _messageLabel.frame.origin.y + _messageLabel.frame.size.height + 5;
    _dateLabel.frame = CGRectMake(60, originY, textWidth, 18);
    _dateLabel.text = [NSString stringWithFormat:@"%@", aDate];
}

- (void)setHeadImage:(UIImage *)aImage {
    [_headButton setBackgroundImage:aImage forState:UIControlStateNormal];
}

+ (CGFloat)calculateCellHeightWithMessage:(BLMessage *)aMessage {
    CGFloat textWidth = [UIScreen mainScreen].bounds.size.width - 70;
    CGSize textSize = [aMessage.text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], }
                                          context:nil].size;
    CGFloat height = textSize.height + 32 + 5 + 18 + 5;
    return height;
}


@end
