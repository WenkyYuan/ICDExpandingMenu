//
//  ViewController.m
//  ICDExpandingMenu
//
//  Created by wenky on 15/10/15.
//  Copyright (c) 2015年 wenky. All rights reserved.
//

#import "ViewController.h"
#import "ICDExpandingMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    ICDExpandingItem *item1 = [[ICDExpandingItem alloc] initWithTitle:@"棋牌" image:[UIImage imageNamed:@"icon_1"] highlightedImage:[UIImage imageNamed:@"icon_1"]];
    ICDExpandingItem *item2 = [[ICDExpandingItem alloc] initWithTitle:@"运动" image:[UIImage imageNamed:@"icon_2"] highlightedImage:[UIImage imageNamed:@"icon_2"]];
    ICDExpandingItem *item3 = [[ICDExpandingItem alloc] initWithTitle:@"聚会" image:[UIImage imageNamed:@"icon_3"] highlightedImage:[UIImage imageNamed:@"icon_3"]];
    ICDExpandingItem *item4 = [[ICDExpandingItem alloc] initWithTitle:@"广场舞" image:[UIImage imageNamed:@"icon_4"] highlightedImage:[UIImage imageNamed:@"icon_4"]];
    ICDExpandingItem *item5 = [[ICDExpandingItem alloc] initWithTitle:@"自定义" image:[UIImage imageNamed:@"icon_3"] highlightedImage:[UIImage imageNamed:@"icon_3"]];
    ICDExpandingItem *centerButton = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_2"] highlightedImage:[UIImage imageNamed:@"icon_2"]];
    NSArray *items = @[item1, item2, item3, item4, item5];
    
    ICDExpandingMenu *menu = [[ICDExpandingMenu alloc] initWithFrame:self.view.bounds menuItems:items centerButton:centerButton];
//    menu.expandingRadius = 150;
    menu.expandingCenter = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 36);
    menu.expandingDirection = ExpandingDirectionCenterUp;
    [self.view addSubview:menu];
}


@end
