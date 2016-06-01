//
//  CollectionCell.m
//  自定义CollectionViewFlowLayout
//
//  Created by 徐茂怀 on 16/6/1.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "CollectionCell.h"
#import "UIImageView+WebCache.h"
@implementation CollectionCell
-(void)awakeFromNib
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
}

-(void)setModel:(Model *)model
{
    _model = model;
     [self.image sd_setImageWithURL:[NSURL URLWithString:_model.img]];
}
@end
