//
//  BookCell.m
//  UIKitPractice
//
//  Created by leon on 20/07/2018.
//  Copyright © 2018 Maimemo Inc. All rights reserved.
//

#import "BookCell.h"


@interface BookCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end


@implementation BookCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = @"sample";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}


- (void)setAuthor:(NSString *)author {

}


@end
