//
//  TypeModel.h
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TypeModel : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,assign)BOOL isEnable;

-(id)initWithDic:(NSDictionary *)dic;

@end

@interface TypeSectionModel: NSObject

@property(nonatomic,strong)NSString *kind;
@property(nonatomic,strong)NSArray *kindValue;
@property(nonatomic,strong)NSMutableArray *data;

-(id)initWithDic:(NSDictionary *)dic;

@end
