//
//  Common.m
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (CGFloat)calculateRowWidth:(NSString *)string font:(UIFont *)font {
    NSDictionary *dic = @{NSFontAttributeName:font};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 36)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
