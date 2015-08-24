//
//  BLCustomCell.h
//  BLTableViewDemo
//
//  Created by 松 段 on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLCustomCellDelegate;

@class BLCellButton;
@class BLMessage;

@interface BLCustomCell : UITableViewCell {
    UILabel                     *_nameLabel;
    UILabel                     *_messageLabel;
    UILabel                     *_dateLabel;
}

@property (nonatomic, strong) BLCellButton *headButton;
@property (nonatomic, assign) id<BLCustomCellDelegate> delegate;

- (void)cleanComponents;

- (void)setComponentsWithMessage:(BLMessage *)aMessage indexPath:(NSIndexPath *)indexPath;
- (void)setName:(NSString *)aName;
- (void)setMessage:(NSString *)aText;
- (void)setDate:(NSDate *)aDate;

- (void)setHeadImage:(UIImage *)aImage;

+ (CGFloat)calculateCellHeightWithMessage:(BLMessage *)aMessage;

@end


@protocol BLCustomCellDelegate <NSObject>

@optional

- (void)headButtonClicked:(BLCellButton *)headButton;

@end
