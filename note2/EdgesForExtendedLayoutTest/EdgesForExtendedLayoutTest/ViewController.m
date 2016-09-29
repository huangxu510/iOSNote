//
//  ViewController.m
//  EdgesForExtendedLayoutTest
//
//  Created by huangxu on 16/4/22.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置导航栏透明单不隐藏
    //[[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    //self.navigationController.navigationBar.translucent = NO;
    //UIRectEdgeNone 在有NavigationController的情况下相当于把self.view整体下移64
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.tableView reloadData];
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleView.backgroundColor = [UIColor clearColor];

    //[self.navigationController.navigationBar.titlevi addSubview:topView];
    self.navigationItem.titleView = titleView;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    topView.backgroundColor = [UIColor blueColor];
    topView.layer.cornerRadius = 30.0f;
    [titleView addSubview:topView];
    
    self.topView = topView;
    
    //UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 617 - 64, 100, 50)];
    //bottomView.backgroundColor = [UIColor yellowColor];
    //[self.view addSubview:bottomView];
    
    
    NSLog(@"self.view.frame  = %@", NSStringFromCGRect(self.view.frame));
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    //cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"offsetY = %f", offset.y);
    
    if (offset.y <= 116) {
        if (offset.y < 0) {
            self.topView.transform = CGAffineTransformMakeScale(1 - offset.y / 300, 1 - offset.y / 300);
        } else if (offset.y > 0) {
            self.topView.transform = CGAffineTransformMakeScale(1 - offset.y / 300, 1 - offset.y / 300);
        }
    }
    
    
    CGRect frame = self.topView.frame;
    frame.origin.y = 0;
    self.topView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
