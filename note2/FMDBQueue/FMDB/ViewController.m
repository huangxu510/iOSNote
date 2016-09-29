//
//  ViewController.m
//  FMDB
//
//  Created by huangxu on 16/2/2.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>

@interface ViewController ()

@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"student.sqlite"];
    
    NSLog(@"filePaht = %@", filePath);
    //创建数据库实例对象
    self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    //打开数据库
    
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"create table if not exists t_student(id integer primary key autoincrement, name text, age integer);"];
        
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }

    }];
}

- (IBAction)insert:(id)sender
{
    [self.queue inDatabase:^(FMDatabase *db) {
        for (NSInteger i = 0; i < 40; i++) {
            NSString *name = [NSString stringWithFormat:@"rose-%d", arc4random() % 1000];
            NSNumber *age = @(arc4random() % 100 + 1);
            [db executeUpdate:@"insert into t_student (name, age) values (?, ?);", name, age];
        }
    }];
    
    //BOOL result = [self.db executeUpdate:@"insert into t_student (name, age) values (?, ?);", @"Kevin", @(20)];
    //if (result) {
        //NSLog(@"插入成功");
    //} else {
        //NSLog(@"插入失败");
    //}
}

- (IBAction)update:(id)sender
{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        //开启事物
        //[db executeUpdate:@"begin transaction;"];
        [db beginTransaction];
        [db executeUpdate:@"update t_student set age = ? where name = ?;", @(30), @"Kevin"];
        [db executeUpdate:@"update t_student set age = ? where name = ?;", @(30), @"Kevin"];
        [db executeUpdate:@"update t_student set age = ? where name = ?;", @(30), @"Kevin"];
        
        
        //回滚事物
        //[db executeUpdate:@"rollback transaction;"];
        [db rollback];
        
        //提交事物
        //[db executeUpdate:@"commit transaction;"];
        [db commit];
    }];
}

- (IBAction)delete:(id)sender
{
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"delete from t_student where age = ?;", @(30)];
        if (result) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    }];
   
#if 0
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        *rollback = YES;
    }];
#endif
}

- (IBAction)query:(id)sender
{
    //查询数据
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"select * from t_student where age > ?;", @(50)];
        
        //遍历结果集
        while ([resultSet next]) {
            NSInteger ID = [resultSet intForColumn:@"id"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSInteger age = [resultSet intForColumn:@"age"];
            
            NSLog(@"%ld, %@, %ld", ID, name, age);
        }

    }];
   }








@end
