//
//  PhotoView.m
//  仿Pinterest首页
//
//  Created by 徐茂怀 on 16/5/31.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "PhotoView.h"
#import "UIImageView+WebCache.h"
#define SCREEN_HEIGHT     ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH      ([[UIScreen mainScreen] bounds].size.width)
@interface PhotoView   ()<UIScrollViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *scrollArr;
@end

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
    }
    return self;
}

-(void)initWithPicArray:(NSMutableArray *)array picNo:(NSInteger)number
{
    _dataArr = [NSMutableArray arrayWithArray:array];
    _scrollArr = [NSMutableArray array];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(array.count * SCREEN_WIDTH, 1);
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * number, 0);
    [self addSubview:_scrollView];
    for (NSInteger i = 0; i < _dataArr.count; i++) {
        Model *model = _dataArr[i];
        UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        scroller.delegate = self;
        scroller.minimumZoomScale = 1.0;
        scroller.maximumZoomScale = 2.0;
        [_scrollArr addObject:scroller];
        [_scrollView addSubview:scroller];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, model.h / model.w * (SCREEN_WIDTH - 20))];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3;
         imageView.tag = 1;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_dataArr[i] img]]];
        [scroller addSubview:imageView];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(10, 10, 32, 32);
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(removeFromsuper) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:backBtn];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(60, 10, 32, 32);
        [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:deleteBtn];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [scroller addGestureRecognizer:doubleTap];
        
    }
}

//双击放大或者缩小
-(void)tapToZoom:(UITapGestureRecognizer *)tap
{
    UIScrollView *zoomable = (UIScrollView*)tap.view;
    if (zoomable.zoomScale > 1.0) {
        [zoomable setZoomScale:1 animated:YES];
    } else {
        [zoomable setZoomScale:2 animated:YES];
    }
}
#pragma mark 缩放停止
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"缩放停止    %.2f", scale);
}

#pragma mark 缩放所对应的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView) {
        UIImageView *imageView = [scrollView viewWithTag:1];
        return imageView;
        
    }
    return nil;
}


-(void)removeFromsuper
{
    [_scrollView removeFromSuperview];
    [self removeFromSuperview];
    if ([self.removeDelegate respondsToSelector:@selector(didremovePicture:)]) {
        [self.removeDelegate didremovePicture:_dataArr];
    }
}

-(void)deletePhoto
{
    NSInteger i =   _scrollView.contentOffset.x / SCREEN_WIDTH;
    
    UIScrollView *scroll = _scrollArr[i];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = scroll.frame;
        frame.origin.y -= SCREEN_HEIGHT;
        scroll.frame = frame;
    } completion:^(BOOL finished) {
         [scroll removeFromSuperview];
    }];
    [_scrollArr removeObjectAtIndex:i];
    [_dataArr removeObjectAtIndex:i];
    [self.removeDelegate deletePicture:_dataArr];
    if (i == _dataArr.count) {
        //最后的一页
    } else {
        //右边的依次往左移动一页
        for (NSInteger j = i ; j < _dataArr.count; j ++) {
            [UIView animateWithDuration:0.5 animations:^{
                UIScrollView *scroll = _scrollArr[j];
                CGRect frame=scroll.frame;
                frame.origin.x -= SCREEN_WIDTH;
                scroll.frame=frame;
            }];
        }
    }
    if (_dataArr.count == 0) {
        [_scrollView removeFromSuperview];
        [self.removeDelegate didremovePicture:_dataArr];
        [self removeFromSuperview];
    }
    _scrollView.contentSize = CGSizeMake((_dataArr.count ) * SCREEN_WIDTH, 1);
}

@end
