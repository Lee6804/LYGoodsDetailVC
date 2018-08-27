//
//  TypeModel.m
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TypeModel.h"

@implementation TypeModel

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.name = dic[@"name"];
        self.isSelected = [dic[@"isSelected"] boolValue];
        self.isEnable = [dic[@"isEnable"] boolValue];
    }
    return self;
}

@end

@implementation TypeSectionModel

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.kind = dic[@"kind"];
        self.kindValue = dic[@"kindValue"];
        
        self.data = [[NSMutableArray alloc] init];
        [self.data removeAllObjects];
        for (NSDictionary *dict in self.kindValue) {
            TypeModel *model = [[TypeModel alloc] initWithDic:dict];
            [self.data addObject:model];
        }
    }
    return self;
}

@end
