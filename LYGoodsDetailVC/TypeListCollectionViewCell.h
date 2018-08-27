//
//  TypeListCollectionViewCell.h
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeModel.h"

typedef void (^btnClickBlock)(void);

@interface TypeListCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIButton *typeBtn;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)TypeModel *model;
@property(nonatomic,strong)NSArray *data;

@property(nonatomic,copy)btnClickBlock btnClickBlock;

+(CGFloat)cellWidth:(TypeModel *)model;

@end
