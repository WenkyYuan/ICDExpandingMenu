//
//  RightUpViewController.m
//  ICDExpandingMenu
//
//  Created by wenky on 15/10/23.
//  Copyright (c) 2015年 wenky. All rights reserved.
//

#import "RightUpViewController.h"
#import "ICDExpandingMenu.h"

@interface RightUpViewController ()<ICDExpandingMenuDelegate>

@end

@implementation RightUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    ICDExpandingItem *item1 = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_1"] highlightedImage:[UIImage imageNamed:@"icon_1"]];
    ICDExpandingItem *item2 = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_2"] highlightedImage:[UIImage imageNamed:@"icon_2"]];
    ICDExpandingItem *item3 = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_3"] highlightedImage:[UIImage imageNamed:@"icon_3"]];
    ICDExpandingItem *item4 = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_4"] highlightedImage:[UIImage imageNamed:@"icon_4"]];
    ICDExpandingItem *item5 = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_3"] highlightedImage:[UIImage imageNamed:@"icon_3"]];
    NSArray *items = @[item1, item2, item3, item4, item5];
    
    ICDExpandingItem *centerButton = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_2"] highlightedImage:[UIImage imageNamed:@"icon_2"]];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    ICDExpandingMenu *menu = [[ICDExpandingMenu alloc] initWithFrame:bounds menuItems:items centerButton:centerButton];
    menu.expandingRadius = 200;
    menu.expandingCenter = CGPointMake(36, bounds.size.height - 36);
    menu.expandingDirection = ExpandingDirectionRightUp;
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (void)icdExpandingMenu:(ICDExpandingMenu *)menu didSelectedAtIndex:(NSInteger)index {
    NSLog(@"didSelectedIndex:%zd", index);
}

@end
