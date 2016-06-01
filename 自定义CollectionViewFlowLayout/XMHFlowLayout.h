//
//  XMHFlowLayout.h
//  自定义CollectionViewFlowLayout
//
//  Created by 徐茂怀 on 16/6/1.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMHFlowLayout;
@protocol XMHFlowLayoutDelegate <NSObject>
/**
 *  这个代理方法用于在viewcontroller中通过Width来计算高度
 *
 *  @param Flow      flowlayout
 *  @param width     图片的宽
 *  @param indexPath indexPath
 *
 *  @return 图片的高
 */
-(CGFloat)Flow:(XMHFlowLayout *)Flow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@end

@interface XMHFlowLayout : UICollectionViewFlowLayout
@property(nonatomic,assign)UIEdgeInsets sectionInset;
@property(nonatomic,assign)CGFloat rowMagrin;//行间距
@property(nonatomic,assign)CGFloat colMagrin;//列间距
@property(nonatomic,assign)CGFloat colCount;//多少列
@property(nonatomic,weak)id<XMHFlowLayoutDelegate>degelate;
@end
