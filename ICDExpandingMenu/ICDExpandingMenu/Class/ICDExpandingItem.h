//
//  ICDExpandingItem.h
//  ICDExpandingMenu
//
//  Created by wenky on 15/10/15.
//  Copyright (c) 2015年 wenky. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((CGFloat)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]
#endif

#ifndef UIColorFromRGBA
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((CGFloat)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
#endif

@class ICDExpandingItem;
@protocol ICDExpandingItemDelegate <NSObject>

- (void)icdExpandingItemTouchesBegan:(ICDExpandingItem *)item;
- (void)icdExpandingItemTouchesEnd:(ICDExpandingItem *)item;
@end

@interface ICDExpandingItem : UIView

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint nearPoint;
@property (nonatomic, assign) CGPoint farPoint;

@property (nonatomic, weak) id<ICDExpandingItemDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)img highlightedImage:(UIImage *)himg;

@end
