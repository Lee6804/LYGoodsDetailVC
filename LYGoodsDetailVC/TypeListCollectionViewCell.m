//
//  TypeListCollectionViewCell.m
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TypeListCollectionViewCell.h"
#import "Common.h"

@interface TypeListCollectionViewCell()



@end

@implementation TypeListCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [btn setTitle:@"6GB+64GB 黑色" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [btn setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = UIColor.darkGrayColor.CGColor;
    btn.layer.borderWidth = 0.5;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.typeBtn = btn;
}

-(void)btnClick:(UIButton *)btn{
    
    TypeSectionModel *sectionModel = self.data[self.indexPath.section];
    [sectionModel.data enumerateObjectsUsingBlock:^(TypeModel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = 0;
    }];
    
   self.model.isSelected = btn.selected ? 0 : 1 ;
    !_btnClickBlock ? : _btnClickBlock();
}

-(void)setModel:(TypeModel *)model{
    _model = model;
    [self.typeBtn setTitle:model.name forState:UIControlStateNormal];
    self.typeBtn.selected = model.isSelected;
    self.typeBtn.enabled = model.isEnable;
    self.typeBtn.layer.borderColor = model.isSelected == 1 ? UIColor.redColor.CGColor : (model.isEnable == 1 ? UIColor.darkGrayColor.CGColor : UIColor.lightGrayColor.CGColor);
}

+(CGFloat)cellWidth:(TypeModel *)model{
    
    return [Common calculateRowWidth:model.name font:[UIFont systemFontOfSize:15]] + 20;
}


#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    CGRect frame = [_model.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 36) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil];
    
    frame.size.height = 36;
    attributes.frame = frame;
    
    self.typeBtn.frame = CGRectMake(0, 0, attributes.frame.size.width + 20, 36);
    
    return attributes;
}

@end
