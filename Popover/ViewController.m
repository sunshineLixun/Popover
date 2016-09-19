//
//  ViewController.m
//  Popover
//
//  Created by lx on 16/9/18.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import "ViewController.h"
#import "PopoverView.h"
#import "TableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@end

@implementation ViewController

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"发起多人聊天",@"加好友",@"扫一扫",@"面对面快传",@"付款"];
    }
    return _titles;
}

- (NSArray *)images
{
    if (!_images) {
        _images = @[@"right_menu_multichat",@"right_menu_addFri",@"right_menu_QR",@"right_menu_facetoface",@"right_menu_payMoney"];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.bounds = CGRectMake(0, 0, 32, 32);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
}
- (void)rightButtonItemAction:(UIButton *)sender
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 150) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 30;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [PopoverView initWithDataSourceView:tableView toItem:sender];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.images[indexPath.row]]];
    cell.title.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.titles[indexPath.row]);
    [PopoverView dismiss];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
