//
//  Person.m
//  DataPersistence
//
//  Created by huangxu on 2017/2/7.
//  Copyright © 2017年 huangxu. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.avatar = [coder decodeObjectForKey:@"avatar"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.age = [coder decodeIntegerForKey:@"age"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.age forKey:@"age"];
}

@end
