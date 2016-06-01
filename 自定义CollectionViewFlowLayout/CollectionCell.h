//
//  CollectionCell.h
//  自定义CollectionViewFlowLayout
//
//  Created by 徐茂怀 on 16/6/1.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
@interface CollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong)Model *model;
@end
