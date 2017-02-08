//
//  ViewController.m
//  DataPersistence
//
//  Created by huangxu on 2017/2/7.
//  Copyright © 2017年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "FMDB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"document = %@", document);
    
//    [self handleKeyedArchiver];
    
//    [self handleUnkeyedArchiver];
    
    [self handleFMDB];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NSKeyedArchiver 

// 归档
- (void)handleKeyedArchiver
{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.plist"];
    
    Person *person = [[Person alloc] init];
    person.avatar = [UIImage imageNamed:@"shangpu.png"];
    person.name = @"NightRaid";
    person.age = 27;
    
    BOOL status = [NSKeyedArchiver archiveRootObject:person toFile:file];
    if (status) {
        NSLog(@"归档成功");
    } else {
        NSLog(@"归档失败");
    }
}

// 解档
- (void)handleUnkeyedArchiver
{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.plist"];
    
    Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:file];

    if (person) {
        NSLog(@"person = %@", person);
    }
}

#pragma mark - FMDB

- (void)handleFMDB
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.db"];
    
    /*
        Path的值可以传入以下三种情况：
     
        1) 具体文件路径，如果不存在会自动创建
        2) 空字符串@""，会在临时目录创建一个空的数据库，当FMDatabase连接关闭时，数据库文件也被删除
        3) nil，会创建一个内存中临时数据库，当FMDatabase连接关闭时，数据库会被销毁
     */
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    
    // 打开数据库
    if (![database open]) {
        NSLog(@"数据库打开失败!");
        return;
    }
    
    // 更新, 在FMDB中，除查询以外的所有操作，都称为“更新”, 如：create、drop、insert、update、delete等操作，使用executeUpdate:方法执行更新
    [database executeUpdate:@"create table if not exists t_person(id integer primary key autoincrement, name text, age integer)"];
    
    [database executeUpdate:@"insert into t_person(name, age) values(?, ?)", @"kevin", @(24)];
}

@end
