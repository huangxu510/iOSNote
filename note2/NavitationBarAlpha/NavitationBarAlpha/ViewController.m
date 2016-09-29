//
//  ViewController.m
//  NavitationBarAlpha
//
//  Created by huangxu on 16/6/3.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"

static NSString *cellId = @"cellId";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIImageView *navigationBarImageView;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataSource = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createUI];
}

- (void)createUI
{
    self.navigationBarImageView = self.navigationController.navigationBar.subviews.firstObject;
    //self.navigationBarImageView.alpha = 0;
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    NSLog(@"offset = %f", offset);
    // -64  1
    //200   0
    CGFloat alpha = (200 - offset) / 264;
    self.navigationBarImageView.alpha = alpha;
}

@end
