//
//  ChooseTypeView.m
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/27.
//  Copyright © 2018年 Lee. All rights reserved.

//**** 此处查询商品关联性使用的是 ORSKUDataFilter 源码出自 github: https://github.com/SunriseOYR/SKUDataFilter

#import "ChooseTypeView.h"
#import "TypeListCollectionViewCell.h"
#import "TypeCollectionReusableHeaderView.h"
#import "TypeCollectionReusableFooterView.h"

#import "ORSKUDataFilter.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@interface ChooseTypeView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ORSKUDataFilterDataSource>

@property(nonatomic,strong)UIWindow *typeWindow;
@property(nonatomic,strong)UIView *typeBackView;
@property(nonatomic,strong)UIImageView *goodsImg;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UILabel *choosedLabel;
@property(nonatomic,strong)UIButton *confirmBtn;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)ORSKUDataFilter *filter;
@property(nonatomic,strong)NSMutableArray *skuData;

@property(nonatomic,strong)NSDictionary *infoDic;
@property(nonatomic,assign)NSInteger stockNum;

@end

@implementation ChooseTypeView


-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)skuData{
    if (!_skuData) {
        _skuData = [NSMutableArray array];
    }
    return _skuData;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 90, SWidth, 310) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator= NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TypeListCollectionViewCell class] forCellWithReuseIdentifier:@"LISTCELL"];
        [_collectionView registerClass:[TypeCollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[TypeCollectionReusableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return  _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenViewClick)]];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SHeight + 20, SWidth, 450)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    self.typeBackView = backView;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hiddenViewClick) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBackView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeBackView.mas_top).offset(5);
        make.right.mas_equalTo(self.typeBackView.mas_right).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    self.closeBtn = closeBtn;
    
    UIImageView *goodsImg = [UIImageView new];
    goodsImg.backgroundColor = [UIColor whiteColor];
    goodsImg.layer.cornerRadius = 5;
    goodsImg.layer.masksToBounds = YES;
    goodsImg.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1].CGColor;
    goodsImg.layer.borderWidth = 0.5;
    [self.typeBackView addSubview:goodsImg];
    [goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeBackView.mas_top).offset(-20);
        make.left.mas_equalTo(self.typeBackView.mas_left).offset(20);
        make.width.height.mas_equalTo(100);
    }];
    self.goodsImg = goodsImg;
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.text = @"¥ 2999.00";
    priceLabel.font = [UIFont systemFontOfSize:25];
    priceLabel.textColor = [UIColor redColor];
    [self.typeBackView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeBtn.mas_bottom);
        make.left.mas_equalTo(self.goodsImg.mas_right).offset(10);
        make.height.mas_equalTo(20);
    }];
    self.priceLabel = priceLabel;
    
    UILabel *countLabel = [UILabel new];
    countLabel.text = @"/件";
    countLabel.font = [UIFont systemFontOfSize:13];
    countLabel.textColor = [UIColor darkGrayColor];
    [self.typeBackView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.mas_centerY);
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(5);
        make.height.mas_equalTo(20);
    }];
    self.countLabel = countLabel;
    
    UILabel *choosedLabel = [UILabel new];
    choosedLabel.text = @"请选择 - -";
    choosedLabel.font = [UIFont systemFontOfSize:13];
    choosedLabel.textColor = [UIColor darkGrayColor];
    [self.typeBackView addSubview:choosedLabel];
    [choosedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5);
        make.left.equalTo(self.priceLabel.mas_left);
        make.right.mas_equalTo(self.typeBackView.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    self.choosedLabel = choosedLabel;
    
    UIButton *confirmBtn = [UIButton new];
    confirmBtn.backgroundColor = [UIColor redColor];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.typeBackView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.typeBackView);
        make.height.mas_equalTo(50);
    }];
    self.confirmBtn = confirmBtn;

    [self.typeBackView addSubview:self.collectionView];
}

-(void)hiddenViewClick{
    
    [self hiddenView];
}

-(void)showView{

    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SWidth, SHeight)];
    [window setWindowLevel:UIWindowLevelAlert];
    [window becomeKeyWindow];
    [window makeKeyAndVisible];
    [window addSubview:self];
    self.typeWindow = window;
    self.typeWindow.hidden = NO;
    
    [self showAnimation];
}

-(void)showAnimation{
    
    [UIView animateWithDuration:0.25 animations:^{
       
        self.typeBackView.frame = CGRectMake(0, SHeight - 450, SWidth, 450);
    }];
}

-(void)hiddenView{
    
    [UIView animateWithDuration:0.25 animations:^{
       
        self.typeBackView.frame = CGRectMake(0, SHeight + 20, SWidth, 450);
    } completion:^(BOOL finished) {

        self.filter = nil;
        [self removeFromSuperview];
        [self.typeWindow resignKeyWindow];
        self.typeWindow.hidden = YES;
    }];
}


-(void)refreshUIWithData:(NSDictionary *)infoDic{
    
    self.infoDic = infoDic;
    [self.dataArr removeAllObjects];
    [self.skuData removeAllObjects];
    
    //更新数据
    [self updateViewDataWithDic:infoDic];
    
    NSArray *skusArr = infoDic[@"skus"];
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];

    for (NSDictionary *skuDetailDic in skusArr) {
        NSMutableDictionary *testDic = [[NSMutableDictionary alloc] init];
        NSArray *attriArr = skuDetailDic[@"attributes"];
        NSMutableArray *testArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in attriArr) {
            NSMutableArray *nArr = [[NSMutableArray alloc] init];
            NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
            [testArr addObject:dict[@"value"]];
            [mutDic setObject:dict[@"key"] forKey:@"kind"];
            if ([arr1 containsObject:mutDic] == NO) {
                [arr1 addObject:mutDic];
            }
            if ([dict[@"key"] isEqualToString:[mutDic objectForKey:@"kind"]]) {
                if ([nArr containsObject:dict[@"value"]] == NO) {
                    [nArr addObject:dict[@"value"]];
                }
            }
        }
        [testDic setObject:[testArr componentsJoinedByString:@","] forKey:@"attributes"];
        [testDic setObject:skuDetailDic[@"mainImage"] forKey:@"mainImage"];
        [testDic setObject:skuDetailDic[@"sellingPrice"] forKey:@"sellingPrice"];
        [testDic setObject:skuDetailDic[@"stockQuantity"] forKey:@"stockQuantity"];
        [self.skuData addObject:testDic];
    }
    
    NSMutableArray *copArr1 = [arr1 mutableCopy];
    for (NSInteger i = 0; i < copArr1.count; i++) {
        NSMutableDictionary *nDic = copArr1[i];
        NSMutableArray *nArr = [[NSMutableArray alloc] init];
        for (NSDictionary *skuDetailDic in skusArr) {
            NSArray *attriArr = skuDetailDic[@"attributes"];
            for (NSDictionary *dict in attriArr) {
                NSMutableDictionary *dicttt = [[NSMutableDictionary alloc] init];
                if ([dict[@"key"] isEqualToString:nDic[@"kind"]]) {
                    [dicttt setObject:dict[@"value"] forKey:@"name"];
                    [dicttt setObject:@(0) forKey:@"isSelected"];
                    [dicttt setObject:@(1) forKey:@"isEnable"];
                    if ([nArr containsObject:dicttt] == NO) {
                        [nArr addObject:dicttt];
                    }
                }
            }
        }
        [nDic setObject:nArr forKey:@"kindValue"];
        if ([arr1 containsObject:nDic] == NO) {
            [arr1 addObject:nDic];
        }
    }
    
    for (NSDictionary *dic in arr1) {
        TypeSectionModel *model = [[TypeSectionModel alloc] initWithDic:dic];
        [self.dataArr addObject:model];
    }

    NSMutableArray *kindArr = [[NSMutableArray alloc] init];
    for (TypeSectionModel *sectionModel in self.dataArr) {
        [kindArr addObject:sectionModel.kind];
    }
    self.choosedLabel.text = [NSString stringWithFormat:@"%@",[kindArr componentsJoinedByString:@" "]];
    
    self.filter = [[ORSKUDataFilter alloc] initWithDataSource:self];
    
    [self.collectionView reloadData];
}

-(void)reloadCol:(NSIndexPath *)indexPath{
    
    //kindTitleArr用于存放 类型名称 如果全部分类都已经选择了一个则数组位空 显示的就是 已选某些种类
    //kindArr用于存放已选的种类 如果kindArr的count和self.dataArr的count相等 则表示所有分类类型都已经选择了 然后再去根据原始的skus数据进行对比 将相应的信息刷新
    NSMutableArray *kindTitleArr = [[NSMutableArray alloc] init];
    NSMutableArray *kindArr = [[NSMutableArray alloc] init];
    
    for (TypeSectionModel *sectionModel in self.dataArr) {
        BOOL allSelected = NO;
        for (TypeModel *model in sectionModel.data) {
            if (model.isSelected == YES) {
                allSelected = YES;
                [kindArr addObject:model.name];
            }
        }
        if (allSelected == NO) {
            [kindTitleArr addObject:sectionModel.kind];
        }
    }
 
    if (kindTitleArr.count != 0) {
        
        self.choosedLabel.text = [NSString stringWithFormat:@"请选择 %@",[kindTitleArr componentsJoinedByString:@" "]];
        
        //勾选后取消任意一个都需要将数据还原
        [self updateViewDataWithDic:self.infoDic];
    }else{
        self.choosedLabel.text = [NSString stringWithFormat:@"已选: %@",[kindArr componentsJoinedByString:@" "]];
    }
    
  
    if (kindArr.count == self.dataArr.count) {
        NSArray *skuArr = self.infoDic[@"skus"];
        for (NSDictionary *skuDetailDic in skuArr) {
            NSMutableArray *checkReloadArr = [[NSMutableArray alloc] init];
            NSArray *attriArr = skuDetailDic[@"attributes"];
            for (NSDictionary *dict in attriArr) {
                [checkReloadArr addObject:dict[@"value"]];
            }
            
            //如果勾选的和遍历出来的arr是相等的 则将此sku的信息刷新到界面上
            if ([kindArr isEqual:checkReloadArr] == YES) {
                //更新数据
                [self updateViewDataWithDic:skuDetailDic];
            }
        }
    }
    
    [self.filter didSelectedPropertyWithIndexPath:indexPath];
    [self.collectionView reloadData];
}

-(void)updateViewDataWithDic:(NSDictionary *)dic{
    
    self.stockNum = [dic[@"stockQuantity"] integerValue];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:dic[@"mainImage"]] placeholderImage:[UIImage imageNamed:@"photo"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[dic[@"sellingPrice"] floatValue]];
}

#pragma mark  UICollectionView Delegate dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    TypeSectionModel *sectionModel = self.dataArr[section];
    return sectionModel.data.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TypeListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LISTCELL" forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    cell.data = self.dataArr;
    TypeSectionModel *sectionModel = self.dataArr[indexPath.section];
    TypeModel *model = sectionModel.data[indexPath.row];
    if ([_filter.availableIndexPathsSet containsObject:indexPath]) {
        model.isSelected = NO;
        model.isEnable = YES;
        
    }else {
        model.isSelected = NO;
        model.isEnable = NO;
    }
    
    if ([_filter.selectedIndexPaths containsObject:indexPath]) {
        model.isSelected = YES;
        model.isEnable = YES;
    }
    
    cell.model = model;
    __weak typeof(self)weakSelf = self;
    cell.btnClickBlock = ^{
        [weakSelf reloadCol:indexPath];
    };
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    TypeSectionModel *sectionModel = self.dataArr[indexPath.section];
    TypeModel *model = sectionModel.data[indexPath.row];
    return  CGSizeMake([TypeListCollectionViewCell cellWidth:model], 36);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        TypeCollectionReusableHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        TypeSectionModel *sectionModel = self.dataArr[indexPath.section];
        headerView.titleLabel.text = sectionModel.kind;
        reusableView = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter && indexPath.section == self.dataArr.count - 1) {
        TypeCollectionReusableFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        [footerView refreshUI:self.stockNum];
        reusableView = footerView;
    }
    return reusableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SWidth, 40);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return section == self.dataArr.count - 1 ? CGSizeMake(SWidth, 70) : CGSizeMake(0, 0);
}


#pragma mark  ORSKUDataFilterDataSource
- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter {
    return self.dataArr.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    TypeSectionModel *model = self.dataArr[section];
    NSMutableArray *filterArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in model.kindValue) {
        [filterArr addObject:dic[@"name"]];
    }
    return filterArr;
}

- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter {
    return self.skuData.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    NSString *condition = self.skuData[row][@"attributes"];
    return [condition componentsSeparatedByString:@","];
}

- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    NSDictionary *dic = _skuData[row];
    return @{@"price": dic[@"sellingPrice"],
             @"store": dic[@"stockQuantity"]};
}



@end
