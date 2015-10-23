//
//  ICDExpandingMenu.h
//  ICDExpandingMenu
//
//  Created by wenky on 15/10/15.
//  Copyright (c) 2015年 wenky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICDExpandingItem.h"

typedef NS_ENUM(NSUInteger, ExpandingDirection) {
    ExpandingDirectionRightUp,
    ExpandingDirectionLeftUp,
    ExpandingDirectionCenterUp,
};

@class ICDExpandingMenu;
@protocol ICDExpandingMenuDelegate <NSObject>

- (void)icdExpandingMenu:(ICDExpandingMenu *)menu didSelectedAtIndex:(NSInteger)index;

@end

@interface ICDExpandingMenu : UIView

@property (nonatomic, assign) CGPoint expandingCenter;

@property (nonatomic, assign) CGFloat expandingRadius;

@property (nonatomic, assign) ExpandingDirection expandingDirection;

@property (nonatomic, readonly, copy) NSArray *itemsArray; //Array of ICDExpandingItem

@property (nonatomic, weak) id<ICDExpandingMenuDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame menuItems:(NSArray *)itemsArray centerButton:(ICDExpandingItem *)centerButton;

@end
