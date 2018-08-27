//
//  Common.h
//  LYGoodsDetailVC
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Common : NSObject

+ (CGFloat)calculateRowWidth:(NSString *)string font:(UIFont *)font;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize;

+ (NSDictionary *)readLocalFileWithName:(NSString *)name;

@end
