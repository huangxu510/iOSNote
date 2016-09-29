//
//  ViewController.m
//  SKTagView
//
//  Created by huangxu on 15/9/29.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import <SKTagButton.h>
#import <SKTagView.h>
#import <Masonry.h>

@interface ViewController ()
@property (nonatomic, strong) SKTagView *tagView;
@property (nonatomic, strong) NSArray *colorPool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.colorPool = @[@"#7ecef4", @"#84ccc9", @"#88abda",@"#7dc1dd",@"#b6b8de"];
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = UIColor.whiteColor;
        view.padding    = UIEdgeInsetsMake(12, 12, 12, 12);
        view.insets    = 15;
        view.lineSpace = 10;
        __weak SKTagView *weakView = view;
        view.didClickTagAtIndex = ^(NSUInteger index){
            //Remove tag
            [weakView removeTagAtIndex:index];
        };
        view;
    });
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = self.view;
        make.centerY.equalTo(superView.mas_centerY).with.offset(0);
        make.leading.equalTo(superView.mas_leading).with.offset(0);
        make.trailing.equalTo(superView.mas_trailing);
    }];
    
    //Add Tags
    [@[@"Python", @"Javascript", @"Python", @"HTML", @"Go", @"Objective-C",@"C", @"PHP"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.fontSize = 15;
         //tag.font = [UIFont fontWithName:@"Courier" size:15];
         tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
         tag.bgColor = [UIColor whiteColor];
         tag.cornerRadius = 5;
         
         [self.tagView addTag:tag];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
