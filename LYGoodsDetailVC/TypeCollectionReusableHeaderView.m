//
//  TypeCollectionReusableHeaderView.m
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TypeCollectionReusableHeaderView.h"


@implementation TypeCollectionReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = UIColor.whiteColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, 40)];
        label.text = @"";
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        self.titleLabel = label;
    }
    
    return self;
}

@end
