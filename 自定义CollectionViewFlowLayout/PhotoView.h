//
//  PhotoView.h
//  仿Pinterest首页
//
//  Created by 徐茂怀 on 16/5/31.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@protocol didRemovePictureDelegate <NSObject>

-(void)didremovePicture:(NSMutableArray *)dataArr;
-(void)deletePicture:(NSMutableArray *)dataArr;
@end

@interface PhotoView : UIView

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, assign)id<didRemovePictureDelegate>removeDelegate;

/**
 *  初始化方法
 *
 *  @param array  照片数组
 *  @param number 第几张照片
 */
-(void)initWithPicArray:(NSMutableArray *)array
                  picNo:(NSInteger)number;

@end
