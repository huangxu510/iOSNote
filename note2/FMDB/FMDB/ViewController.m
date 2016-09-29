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

@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"student.sqlite"];
    
    NSLog(@"filePaht = %@", filePath);
    //创建数据库实例对象
    self.db = [FMDatabase databaseWithPath:filePath];
    
    //打开数据库
    if ([self.db open]) {
        //创表
        BOOL result = [self.db executeUpdate:@"create table if not exists t_student(id integer primary key autoincrement, name text, age integer);"];
        
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    } else {
        NSLog(@"数据库打开失败");
    }
}

- (IBAction)insert:(id)sender
{
    for (NSInteger i = 0; i < 40; i++) {
        NSString *name = [NSString stringWithFormat:@"rose-%d", arc4random() % 1000];
        NSNumber *age = @(arc4random() % 100 + 1);
        [self.db executeUpdate:@"insert into t_student (name, age) values (?, ?);", name, age];
    }
    //BOOL result = [self.db executeUpdate:@"insert into t_student (name, age) values (?, ?);", @"Kevin", @(20)];
    //if (result) {
        //NSLog(@"插入成功");
    //} else {
        //NSLog(@"插入失败");
    //}
}

- (IBAction)update:(id)sender
{
    BOOL result = [self.db executeUpdate:@"update t_student set age = ? where name = ?;", @(30), @"Kevin"];
    if (result) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
}

- (IBAction)delete:(id)sender
{
    BOOL result = [self.db executeUpdate:@"delete from t_student where age = ?;", @(30)];
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

- (IBAction)query:(id)sender
{
    //查询数据
    FMResultSet *resultSet = [self.db executeQuery:@"select * from t_student where age > ?;", @(50)];
    
    //遍历结果集
    while ([resultSet next]) {
        NSInteger ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSInteger age = [resultSet intForColumn:@"age"];
        
        NSLog(@"%ld, %@, %ld", ID, name, age);
    }
}








@end
