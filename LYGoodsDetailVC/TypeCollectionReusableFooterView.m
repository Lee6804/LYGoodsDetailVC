//
//  TypeCollectionReusableFooterView.m
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TypeCollectionReusableFooterView.h"
#import "Masonry.h"

@interface TypeCollectionReusableFooterView()

@property(nonatomic,strong)UILabel *buyCountTitleLabel;
@property(nonatomic,strong)UILabel *stockLabel;
@property(nonatomic,strong)UIButton *reduceBtn;
@property(nonatomic,strong)UITextField *countTF;
@property(nonatomic,strong)UIButton *addBtn;

@property(nonatomic,assign)NSInteger stockNum;

@end

@implementation TypeCollectionReusableFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UILabel *buyCountTitleLabel = [UILabel new];
    buyCountTitleLabel.font = [UIFont systemFontOfSize:17];
    buyCountTitleLabel.textColor = [UIColor blackColor];
    buyCountTitleLabel.text = @"购买数量";
    [self addSubview:buyCountTitleLabel];
    [buyCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(25);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.height.mas_equalTo(20);
    }];
    self.buyCountTitleLabel = buyCountTitleLabel;
    
    UILabel *stockLabel = [UILabel new];
    stockLabel.font = [UIFont systemFontOfSize:15];
    stockLabel.textColor = [UIColor lightGrayColor];
    stockLabel.text = @"库存(0)";
    [self addSubview:stockLabel];
    [stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buyCountTitleLabel);
        make.left.mas_equalTo(self.buyCountTitleLabel.mas_right).offset(5);
        make.height.mas_equalTo(20);
    }];
    self.stockLabel = stockLabel;
    
    UIButton *addBtn = [UIButton new];
    [addBtn setTitle:@"＋" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    addBtn.backgroundColor = [UIColor  colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    addBtn.tag = 1001;
    [addBtn addTarget:self action:@selector(changeCountClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.width.height.mas_equalTo(30);
    }];
    self.addBtn = addBtn;
    
    UITextField *countTF = [UITextField new];
    countTF.backgroundColor = [UIColor  colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    countTF.text = @"1";
    countTF.font = [UIFont boldSystemFontOfSize:17];
    countTF.textColor = [UIColor blackColor];
    countTF.textAlignment = NSTextAlignmentCenter;
    countTF.keyboardType = UIKeyboardTypeNumberPad;
    countTF.enabled = NO;
    [self addSubview:countTF];
    [countTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.addBtn);
        make.right.mas_equalTo(self.addBtn.mas_left).offset(-1);
    }];
    self.countTF = countTF;
    
    UIButton *reduceBtn = [UIButton new];
    [reduceBtn setTitle:@"－" forState:UIControlStateNormal];
    [reduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reduceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    reduceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    reduceBtn.backgroundColor = [UIColor  colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    reduceBtn.tag = 1000;
    [reduceBtn addTarget:self action:@selector(changeCountClick:) forControlEvents:UIControlEventTouchUpInside];
    reduceBtn.enabled = NO;
    [self addSubview:reduceBtn];
    [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.addBtn);
        make.right.mas_equalTo(self.countTF.mas_left).offset(-1);
    }];
    self.reduceBtn = reduceBtn;
}

-(void)changeCountClick:(UIButton *)btn{

    NSInteger count = [self.countTF.text integerValue];
    switch (btn.tag) {
        case 1000:
            count -= 1;
            btn.enabled = count == 1 ? NO : YES;
            break;
        case 1001:
            if (count == self.stockNum) {
                NSLog(@"没有库存咯~");
                return;
            }
            count += 1;
            self.reduceBtn.enabled = YES;
            break;
            
        default:
            break;
    }
    
    self.countTF.text = [NSString stringWithFormat:@"%ld",count];
}

-(void)refreshUI:(NSInteger)stockNum{
    
    self.stockNum = stockNum;
    self.stockLabel.text = [NSString stringWithFormat:@"库存(%ld)",stockNum];
    self.countTF.text = @"1";
    self.reduceBtn.enabled = NO;
}

@end
