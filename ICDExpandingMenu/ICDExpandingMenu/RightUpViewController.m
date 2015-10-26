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
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 5; i ++) {
        NSString *imageNameStr = [NSString stringWithFormat:@"icon_%zd", i];
        ICDExpandingItem *item = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:imageNameStr] highlightedImage:[UIImage imageNamed:imageNameStr]];
        [itemArray addObject:item];
    }
    
    ICDExpandingItem *centerButton = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_2"] highlightedImage:[UIImage imageNamed:@"icon_2"]];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    ICDExpandingMenu *menu = [[ICDExpandingMenu alloc] initWithFrame:bounds
                                                           menuItems:[itemArray copy]
                                                        centerButton:centerButton];
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
