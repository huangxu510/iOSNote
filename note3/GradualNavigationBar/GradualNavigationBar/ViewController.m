//
//  ViewController.m
//  GradualNavigationBar
//
//  Created by huangxu on 16/9/30.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"

#define kHeaderImageViewHeight 260
#define kNavBarHeight 64
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *barImageView;
@property (nonatomic, strong) UIImageView *scaleImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _barImageView = self.navigationController.navigationBar.subviews.firstObject;
    _barImageView.alpha = 0;
    
    UIImageView *bottomLineImageView = _barImageView.subviews.lastObject;
    bottomLineImageView.alpha = 0;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.scaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shangpu.jpg"]];
    self.scaleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.scaleImageView.clipsToBounds = YES;
    self.scaleImageView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderImageViewHeight - 35);
    [self.view addSubview:self.scaleImageView];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(kHeaderImageViewHeight - 35, 0, 0, 0);
    }
    
    return _tableView;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = offset / (maxAlphaOffset - minAlphaOffset);
    _barImageView.alpha = alpha;
    
    CGRect originFrame = CGRectMake(0, 0, kScreenWidth, kHeaderImageViewHeight);
//    if (offset <= 0) {
//        //放大图片
    offset = MIN(offset, 0);
        originFrame.size.height = fabs(offset);
        self.scaleImageView.frame = originFrame;
//    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}


@end
