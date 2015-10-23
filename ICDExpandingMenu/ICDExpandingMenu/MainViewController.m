//
//  MainViewController.m
//  ICDExpandingMenu
//
//  Created by wenky on 15/10/23.
//  Copyright (c) 2015年 wenky. All rights reserved.
//

#import "MainViewController.h"
#import "RightUpViewController.h"
#import "LeftUpViewController.h"
#import "CenterUpViewController.h"

static NSString *const kTableViewCellIdentifier = @"kTableViewCellIdentifier";

@interface MainViewController ()<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Direction";
    self.view.backgroundColor = [UIColor purpleColor];
    if (self.navigationController) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setupData];
    [self setupTableView];
}

- (void)setupData {
    self.dataSource = @[@"ExpandingDirectionRightUp", @"ExpandingDirectionLeftUp", @"ExpandingDirectionCenterUp"];
}

- (void)setupTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc;
    if (indexPath.row == 0) {
        vc = [[RightUpViewController alloc] init];
    } else if (indexPath.row == 1) {
        vc = [[LeftUpViewController alloc] init];
    } else {
        vc = [[CenterUpViewController alloc] init];
    }
    vc.title = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
