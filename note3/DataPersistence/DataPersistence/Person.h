//
//  Person.h
//  DataPersistence
//
//  Created by huangxu on 2017/2/7.
//  Copyright © 2017年 huangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject <NSCoding>

@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end
