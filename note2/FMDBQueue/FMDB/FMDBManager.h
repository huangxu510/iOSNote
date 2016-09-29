//
//  FMDBManager.h
//  FMDBQueue
//
//  Created by huangxu on 16/2/2.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface FMDBManager : NSObject

+ (instancetype)shareInstance;

//! @brief 创建表
- (void)creatTable:(id)model;

//! @brief 数据库增加或更新
-(void)insertAndUpdateModelToDatabase:(id)model;


//! @brief 数据库删除元素
-(void)deleteModelInDatabase:(id)model;


//! @brief 数据库通过表名查询所有对应表的所有值
- (NSArray *)selectModelArrayInDatabase:(NSString *)className;

@end
