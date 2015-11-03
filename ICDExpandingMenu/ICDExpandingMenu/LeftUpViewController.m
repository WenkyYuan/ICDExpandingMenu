//
//  LeftUpViewController.m
//  ICDExpandingMenu
//
//  Created by wenky on 15/10/23.
//  Copyright (c) 2015年 wenky. All rights reserved.
//

#import "LeftUpViewController.h"
#import "ICDExpandingMenu.h"

@interface LeftUpViewController ()<ICDExpandingMenuDelegate>

@end

@implementation LeftUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 5; i ++) {
        NSString *imageNameStr = [NSString stringWithFormat:@"icon_%zd", i];
        NSString *imageHighlightNameStr = [NSString stringWithFormat:@"icon_%zd_highlight", i];
        ICDExpandingItem *item = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:imageNameStr] highlightedImage:[UIImage imageNamed:imageHighlightNameStr]];
        [itemArray addObject:item];
    }
    
    ICDExpandingItem *centerButton = [[ICDExpandingItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"activity_publish_icon_normal"] highlightedImage:[UIImage imageNamed:@"activity_publish_icon_highlight"]];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    ICDExpandingMenu *menu = [[ICDExpandingMenu alloc] initWithFrame:bounds
                                                           menuItems:[itemArray copy]
                                                        centerButton:centerButton];
    menu.expandingRadius = 200;
    menu.expandingCenter = CGPointMake(bounds.size.width - 36, bounds.size.height - 36);
    menu.expandingDirection = ExpandingDirectionLeftUp;
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (void)icdExpandingMenu:(ICDExpandingMenu *)menu didSelectedAtIndex:(NSInteger)index {
    NSLog(@"didSelectedIndex:%zd", index);
}

@end
