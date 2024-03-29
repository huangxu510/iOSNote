//
//  FMDBManager.m
//  FMDBQueue
//
//  Created by huangxu on 16/2/2.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "FMDBManager.h"
#import <objc/runtime.h>

// 通过实体获取类名
#define KCLASS_NAME(model) NSStringFromClass([model class])

// 通过实体获取属性数组
#define KMODEL_PROPERTYS [self getAllProperties:model]

// 通过实体获取属性数组数目
#define KMODEL_PROPERTYS_COUNT [[self getAllProperties:model] count]


static FMDBManager *manager = nil;
@implementation FMDBManager
{
    FMDatabaseQueue *_dbQueue;
}
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc] init];
    });
    return manager;
}

- (void)creatTable:(id)model
{
    if (!_dbQueue) {
        [self creatDataBaseQueue];
    }
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        
        //为数据库设置缓存，提高查询效率
        [db setShouldCacheStatements:YES];
        
        //判断数据库中是否已经存在这个表，如果不存在则创建该表
        if (![db tableExists:KCLASS_NAME(model)]) {
            
            NSString *createTableStrOne = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key)", KCLASS_NAME(model)];
            
            NSMutableString *createTableStrTwo = [NSMutableString string];
            for (NSString *propertyName in KMODEL_PROPERTYS) {
                [createTableStrTwo appendFormat:@",%@ text", propertyName];
            }
            
            NSString *createTableStr = [NSString stringWithFormat:@"%@%@", createTableStrOne, createTableStrTwo];
            
            if ([db executeUpdate:createTableStr]) {
                NSLog(@"创建表成功");
            }
        }
        
        //关闭数据库
        [db close];
    }];
}

//插入或更新实体
- (void)insertAndUpdateModelToDatabase:(id)model
{
    if (!_dbQueue) {
        [self creatDataBaseQueue];
    }
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 判断数据库能否打开
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        // 设置数据库缓存
        [db setShouldCacheStatements:YES];
        
        // 判断是否存在对应的userModel表
        if(![db tableExists:KCLASS_NAME(model)])
        {
            [self creatTable:model];
        }
        
        // 以前的查询语句  select *from ZDDUserModel where user_id = ?
        // 后台不可能有重复的用户id（譬如QQ号码）用户的唯一标示user_id来表示
        NSString *selectStr = [NSString stringWithFormat:@"select *from %@ where %@ = ?",KCLASS_NAME(model),[KMODEL_PROPERTYS objectAtIndex:0]];
        // 获取对应属性的对应值
        FMResultSet * resultSet = [db executeQuery:selectStr,[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
        if ([resultSet next]) {
            // 如果有[resultSet next]的话，本次做更新操作
            // 以前的更新语句 update ZDDUserModel set userId = ?,userName = ?,email = ? where user_id =%@
            
            // 更新语句第一部分
            NSString *updateStrOne = [NSString stringWithFormat:@"update %@ set ",KCLASS_NAME(model)];
            // 更新语句第二部分
            NSMutableString *updateStrTwo = [NSMutableString string];
            for (int i = 0;i< KMODEL_PROPERTYS_COUNT;i++) {
                
                [updateStrTwo appendFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:i]];
                
                if (i != KMODEL_PROPERTYS_COUNT -1) {
                    [updateStrTwo appendFormat:@","];
                }
            }
            // 更新语句第二部分
            NSString *updateStrThree = [NSString stringWithFormat:@"where %@ = %@",[KMODEL_PROPERTYS objectAtIndex:0], [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
            
            // 更新总语句
            NSString *updateStr = [NSString stringWithFormat:@"%@%@%@",updateStrOne,updateStrTwo,updateStrThree];
            // 属性值数组
            NSMutableArray *propertyValue = [NSMutableArray array];
            for (NSString *property in KMODEL_PROPERTYS) {
                [propertyValue addObject:[model valueForKey:property]];
            }
            // 调用更新
            if([db executeUpdate:updateStr withArgumentsInArray:propertyValue])
            {
                NSLog(@"调用更新成功");
            };
        }
        else
        {
            // 本次做插入操作
            // 以前插入的句子 insert into ZDDUserModel (user_id,userName,userIcon,expirationDate) values (?,?,?,?)
            
            // 插入语句第一部分
            NSString *insertStrOne = [NSString stringWithFormat:@"insert into %@ (",KCLASS_NAME(model)];
            // 插入语句第二部分
            NSMutableString *insertStrTwo =[NSMutableString string];
            for (int i =0; i<KMODEL_PROPERTYS_COUNT; i++) {
                [insertStrTwo appendFormat:@"%@",[KMODEL_PROPERTYS objectAtIndex:i]];
                if (i!=KMODEL_PROPERTYS_COUNT -1) {
                    [insertStrTwo appendFormat:@","];
                }
            }
            // 插入语句第三部分
            NSString *insertStrThree =[NSString stringWithFormat:@") values ("];
            // 插入语句第四部分
            NSMutableString *insertStrFour =[NSMutableString string];
            for (int i =0; i<KMODEL_PROPERTYS_COUNT; i++) {
                [insertStrFour appendFormat:@"?"];
                if (i!=KMODEL_PROPERTYS_COUNT -1) {
                    [insertStrFour appendFormat:@","];
                }
            }
            // 插入整个语句
            NSString *insertStr = [NSString stringWithFormat:@"%@%@%@%@)",insertStrOne,insertStrTwo,insertStrThree,insertStrFour];
            // 属性值数组
            NSMutableArray *propertyValue = [NSMutableArray array];
            for (NSString *property in KMODEL_PROPERTYS) {
                // 每一次遍历属性数组，通过valueForKey获取属性的值
                [propertyValue addObject:[model valueForKey:property]];
            }
            // 调用插入
            if([db executeUpdate:insertStr withArgumentsInArray:propertyValue])
            {
                NSLog(@"插入成功");
            }
            
            // 关闭数据库
            [db close];
        }
    }];
}

- (void)deleteModelInDatabase:(id)model
{
    // 如果db操作队列不存在
    if (!_dbQueue) {
        // 创建数据库
        [self creatDataBaseQueue];
    }
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 判断数据是否已经打开
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        // 设置数据库缓存，优点：高效
        [db setShouldCacheStatements:YES];
        
        // 判断是否有该表
        if(![db tableExists:KCLASS_NAME(model)])
        {
            [self creatTable:model];
        }
        
        // 以前的数据库语句 delete from tableName where user_id = ?;
        NSString *deleteStr = [NSString stringWithFormat:@"delete from %@ where %@ = ?",KCLASS_NAME(model),[KMODEL_PROPERTYS objectAtIndex:0]];
        
        if([db executeUpdate:deleteStr,[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]])
        {
            NSLog(@"删除成功");
        }
        // 关闭数据库
        [db close];
        
    }];
}

- (NSArray *)selectModelArrayInDatabase:(NSString *)tableName
{
    // 如果db操作队列不存在
    if (!_dbQueue) {
        // 创建数据库
        [self creatDataBaseQueue];
    }
    __block NSMutableArray *modelArray = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"数据库打开失败");
        }
        
        [db setShouldCacheStatements:YES];
        
        // select *from ZDDUserModel
        // 查询整个表的语句
        NSString * selectStr = [NSString stringWithFormat:@"select *from %@",tableName];
        
        FMResultSet *resultSet = [db executeQuery:selectStr];
        while([resultSet next]) {
            // 使用表名作为类名创建对应的类的对象
            id model = [[NSClassFromString(tableName) alloc]init];
            for (int i =0; i< KMODEL_PROPERTYS_COUNT; i++) {
                // 值是从我们的数据表的Column字段取出来，
                ;
                [model setValue:[resultSet stringForColumn:[KMODEL_PROPERTYS objectAtIndex:i]] forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            }
            [modelArray addObject:model];
        }
    }];
    return modelArray;
}


- (void)creatDataBaseQueue
{
    _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self databaseFilePath]];
}

- (NSString *)databaseFilePath
{
     NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"db.sqlite"];
    return filePath;
}



/**
 *  传递一个model实体
 *
 *  @param model 实体
 *
 *  @return 实体的属性
 */
- (NSArray *)getAllProperties:(id)model
{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList([model class], &count);
    
    // 定义一个可变的属性数组
    NSMutableArray *propertiesArray = [NSMutableArray array];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    return propertiesArray;
}

@end
