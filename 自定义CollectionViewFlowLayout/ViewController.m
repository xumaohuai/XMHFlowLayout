//
//  ViewController.m
//  自定义CollectionViewFlowLayout
//
//  Created by 徐茂怀 on 16/6/1.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "ViewController.h"
#import "PhotoView.h"
#import "CollectionCell.h"
#import "XMHFlowLayout.h"
#import "Model.h"
#import "MJExtension.h"
#define SCREEN_HEIGHT     ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH      ([[UIScreen mainScreen] bounds].size.width)
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,XMHFlowLayoutDelegate,didRemovePictureDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic, assign)CGRect transformedFrame;
@property (nonatomic, strong)UIImageView *lookImg;
@property (nonatomic , strong)PhotoView* photoView;
@property (nonnull, strong)XMHFlowLayout *layOut;
@end

@implementation ViewController

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    _collection.delegate = self;
    _collection.dataSource = self;
    _layOut = [[XMHFlowLayout alloc] init];
    _layOut.degelate =self;
    [_collection setCollectionViewLayout:_layOut];
    
    //初始化数据
    NSArray * arr = [Model objectArrayWithFilename:@"1.plist"];
    [self.dataArr addObjectsFromArray:arr];

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setModel:_dataArr[indexPath.row]];
    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    return cell;
}

-(CGFloat)Flow:(XMHFlowLayout *)Flow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath{
    Model *model = self.dataArr[indexPath.row];
    return  model.h/model.w*width;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_lookImg) {
        return;
    }
    Model *model = _dataArr[indexPath.row];
    CollectionCell *cell = (CollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _transformedFrame = [cell convertRect:cell.image.frame toView:[UIApplication sharedApplication].keyWindow];
    _lookImg = [[UIImageView alloc]initWithFrame:_transformedFrame];
    _lookImg.image = cell.image.image;
    [[UIApplication sharedApplication].keyWindow addSubview:_lookImg];
    [UIView animateWithDuration:0.1 animations:^{
        _lookImg.frame = CGRectMake(10, 40, SCREEN_WIDTH - 20, model.h / model.w * (SCREEN_WIDTH - 20));
        self.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        _photoView = [[PhotoView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        [_photoView initWithPicArray:_dataArr picNo:indexPath.row];
        _photoView.removeDelegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_photoView];
        
    }];
}

-(void)didremovePicture:(NSMutableArray *)shopArr{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    NSInteger i =   _photoView.scrollView.contentOffset.x / SCREEN_WIDTH;
    CollectionCell *cell = (CollectionCell *)[_collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    _transformedFrame = [cell.superview convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
    _lookImg.image = cell.image.image;
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1;
        _lookImg.frame = _transformedFrame;
    } completion:^(BOOL finished) {
        [_lookImg removeFromSuperview];
        _lookImg = nil;
        _dataArr = [NSMutableArray arrayWithArray:shopArr];
        [_collection reloadData];
    }];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)deletePicture:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    [_collection reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
