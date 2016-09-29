//
//  ViewController.m
//  PlistTexgt
//
//  Created by huangxu on 15/11/6.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getDirectory];
    [self plistTest];
}

- (void)plistTest
{
    //读取bundle内的plist数据
    NSString *testPlistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSMutableDictionary *rootDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:testPlistPath];
    
    //读写document内的plist数据
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"citys.plist"];
   
    NSArray *citys = @[@"深圳", @"西安", @"北京"];
    [citys writeToFile:filePath atomically:YES];
     NSMutableArray *rootArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    [rootArray addObject:@"上海"];
    [rootArray writeToFile:filePath atomically:YES];
}

- (void)getDirectory
{
    //1，获取家目录路径的函数：
    NSString *homeDir = NSHomeDirectory();
    NSLog(@"homeDir = %@", homeDir);
    //2，获取Documents目录路径的方法：
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    //3，获取Caches目录路径的方法：
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    //4，获取tmp目录路径的方法：
    NSString *tmpDir = NSTemporaryDirectory();
    
    //5，获取应用程序程序包中资源文件路径的方法：
    //例如获取程序包中一个图片资源（apple.png）路径的方法：
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"apple"ofType:@"png"];
    UIImage *appleImage = [[UIImage alloc]initWithContentsOfFile:imagePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
