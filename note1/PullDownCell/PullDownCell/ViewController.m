//
//  ViewController.m
//  PullDownCell
//
//  Created by huangxu on 15/12/4.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "PulldownTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tb;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6"]];
    _tb = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tb];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    PulldownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PulldownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger row = indexPath.row;
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PulldownTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text length] == 1)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        if (cell.isPullDown) {
            [self.dataSource removeObjectAtIndex:indexPath.row + 1];
            [tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NSString *str = @"book0";
            
            [self.dataSource insertObject:str atIndex:indexPath.row + 1];
            [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        }
        cell.isPullDown = !cell.isPullDown;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.dataSource[indexPath.row];
    if ([str length] == 1) {
        return 40;
    }
    else
    {
        return 80;
    }
}


@end
