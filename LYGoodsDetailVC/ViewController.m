//
//  ViewController.m
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ViewController.h"
#import "TypeListCollectionViewCell.h"
#import "TypeModel.h"
#import "TypeCollectionReusableHeaderView.h"


#import "Common.h"
#import "ORSKUDataFilter.h"

#import "ChooseTypeView.h"

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ORSKUDataFilterDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSDictionary *infoDic;

@property(nonatomic,strong)NSMutableArray *skuData;

@property (nonatomic, strong) ORSKUDataFilter *filter;

@property(nonatomic,strong)ChooseTypeView *chooseTypeView;

@end

@implementation ViewController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SWidth, SHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator= NO;
        _collectionView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        [_collectionView registerClass:[TypeListCollectionViewCell class] forCellWithReuseIdentifier:@"LISTCELL"];
        [_collectionView registerClass:[TypeCollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return  _collectionView;
}

-(void)chooseType{
    [self.chooseTypeView showView];
    [self.chooseTypeView refreshUIWithData:self.infoDic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 120, 44);
    btn.center = self.view.center;
    [btn setTitle:@"选择分类" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(chooseType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    NSDictionary *dic = [Common readLocalFileWithName:@"product"];
    self.infoDic = dic;
    NSArray *skusArr = dic[@"skus"];
    
    self.dataArr = [[NSMutableArray alloc] init];
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    
    self.skuData = [[NSMutableArray alloc] init];

//    NSLog(@"%@",skusArr);
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
    
//    NSLog(@"%@",arr1);
    
    for (NSDictionary *dic in arr1) {
        TypeSectionModel *model = [[TypeSectionModel alloc] initWithDic:dic];
        [self.dataArr addObject:model];
    }
    
    _filter = [[ORSKUDataFilter alloc] initWithDataSource:self];
    
//    [self.view addSubview:self.collectionView];
    
    self.chooseTypeView = [[ChooseTypeView alloc] initWithFrame:CGRectMake(0, 0, SWidth, SHeight)];
}

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
        
        [weakSelf.filter didSelectedPropertyWithIndexPath:indexPath];
        
        [weakSelf changeDataForView];
        
        [weakSelf.collectionView reloadData];
//        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
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
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        reusableView.backgroundColor = UIColor.yellowColor;
    }
    return reusableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SWidth, 40);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return section == self.dataArr.count - 1 ? CGSizeMake(SWidth, 70) : CGSizeMake(0, 0);
}


-(void)changeDataForView{

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
    
    if (kindArr.count != self.dataArr.count && kindArr.count != 0) {
        
        

        for (NSInteger i = 0; i < kindArr.count; i++) {
            
        }
    }
//    NSLog(@"%@ ----- %@",kindTitleArr,kindArr);
}

#pragma mark -- ORSKUDataFilterDataSource

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
