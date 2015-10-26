//
//  ICDExpandingMenu.m
//  ICDExpandingMenu
//
//  Created by wenky on 15/10/15.
//  Copyright (c) 2015年 wenky. All rights reserved.
//

#import "ICDExpandingMenu.h"

#define EXPANDRADIUS 180.0f
#define STARTPOINT CGPointMake(CGRectGetWidth(self.bounds) - 36, CGRectGetHeight(self.bounds) - 36)
#define TIMEOFFSET 0.03f
#define BOUNCEREGION_TOP 30
#define BOUNCEREGION_BOTTOM 10

static const CGFloat kColSpacingForCenterUp = 50;

@interface ICDExpandingMenu ()<ICDExpandingItemDelegate>
@property (nonatomic, assign) ICDExpandingItem *centerButton;
@property (nonatomic, assign) BOOL expanding;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation ICDExpandingMenu

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame menuItems:(NSArray *)itemsArray centerButton:(ICDExpandingItem *)centerButton {
    self = [super initWithFrame:frame];
    if (self) {
        _itemsArray = [itemsArray copy];
        
        NSUInteger count = _itemsArray.count;
        for (NSUInteger i = 0; i < count; i ++) {
            ICDExpandingItem *item = _itemsArray[i];
            item.tag = 1000 + i;
            item.delegate = self;
            [self addSubview:item];
        }
        _centerButton = centerButton;
        _centerButton.delegate = self;
        [self addSubview:_centerButton];
        
        [self setupDefualtValues];
    }
    return self;
}

- (void)setupDefualtValues {
    _expandingCenter = STARTPOINT;
    _expandingRadius = EXPANDRADIUS;
    _expandingDirection = ExpandingDirectionLeftUp;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat boundsHeight = CGRectGetHeight(self.bounds);
    CGFloat boundsWidth = CGRectGetWidth(self.bounds);
    
    CGFloat nearRadius = _expandingRadius - BOUNCEREGION_BOTTOM;
    CGFloat farRadius = _expandingRadius + BOUNCEREGION_TOP;
    CGPoint startPoint = _expandingCenter;

    NSUInteger count = _itemsArray.count;
    for (NSUInteger i = 0; i < count; i ++) {
        CGPoint endPoint = CGPointZero;
        CGPoint nearPoint = CGPointZero;
        CGPoint farPoint = CGPointZero;
        if (_expandingDirection == ExpandingDirectionRightUp) {
            endPoint = CGPointMake(startPoint.x + _expandingRadius * sinf(i * M_PI_2 / (count - 1)), startPoint.y - _expandingRadius * cosf(i * M_PI_2 / (count - 1)));
            nearPoint = CGPointMake(startPoint.x + nearRadius * sinf(i * M_PI_2 / (count - 1)), startPoint.y - nearRadius * cosf(i * M_PI_2 / (count - 1)));
            farPoint = CGPointMake(startPoint.x + farRadius * sinf(i * M_PI_2 / (count - 1)), startPoint.y - farRadius * cosf(i * M_PI_2 / (count - 1)));
            
        } else if (_expandingDirection == ExpandingDirectionLeftUp) {
            endPoint = CGPointMake(startPoint.x - _expandingRadius * sinf(i * M_PI_2 / (count - 1)), startPoint.y - _expandingRadius * cosf(i * M_PI_2 / (count - 1)));
            nearPoint = CGPointMake(startPoint.x - nearRadius * sinf(i * M_PI_2 / (count - 1)), startPoint.y - nearRadius * cosf(i * M_PI_2 / (count - 1)));
            farPoint = CGPointMake(startPoint.x - farRadius * sinf(i * M_PI_2 / (count - 1)), startPoint.y - farRadius * cosf(i * M_PI_2 / (count - 1)));
        } else if (_expandingDirection == ExpandingDirectionCenterUp) {
            ICDExpandingItem *firstItem = _itemsArray.firstObject;
            CGFloat itemWidth = firstItem.bounds.size.width;
            CGFloat itemHeight = firstItem.bounds.size.height;
            
            CGFloat horizontalSpacing = (boundsWidth - 3 * itemWidth) / 4;
            CGFloat verticalSpacing = kColSpacingForCenterUp;
            NSInteger verticalNum = count / 3 + (count % 3 ? 1 : 0);
            
            CGFloat originX = horizontalSpacing + itemWidth / 2;
            CGFloat originY = boundsHeight / 2 - (verticalNum * itemHeight + verticalSpacing) / 2 + itemHeight / 2;
            
            startPoint = CGPointMake(originX + (i % 3) * (itemWidth + horizontalSpacing), boundsHeight + (i / 3) * (itemHeight + verticalSpacing) + itemHeight / 2);
            endPoint = CGPointMake(originX + (i % 3) * (itemWidth + horizontalSpacing), originY + (i / 3) * (itemHeight + verticalSpacing));
            nearPoint = CGPointMake(endPoint.x, endPoint.y + BOUNCEREGION_BOTTOM);
            farPoint = CGPointMake(endPoint.x, endPoint.y - BOUNCEREGION_TOP);
        }
        ICDExpandingItem *item = _itemsArray[i];
        item.startPoint = startPoint;
        item.endPoint = endPoint;
        item.nearPoint = nearPoint;
        item.farPoint = farPoint;
    }
    _centerButton.center = _expandingCenter;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_expanding) {
        return YES;
    } else {
        //非展开状态下，centerButton之外点击事件无效
        return CGRectContainsPoint(self.centerButton.frame, point);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.expanding = !self.expanding;
}

#pragma mark - ICDExpandingItemDelegate
- (void)icdExpandingItemTouchesBegan:(ICDExpandingItem *)item {
    if (item == self.centerButton) {
        self.expanding = !self.expanding;
    }
}

- (void)icdExpandingItemTouchesEnd:(ICDExpandingItem *)item {
    if (item == self.centerButton) {
        return;
    }
    self.selectedIndex = item.tag - 1000;
    
    CAAnimationGroup *blowupAnim = [self blowupAnimationAtPoint:item.center];
    [item.layer addAnimation:blowupAnim forKey:@"blowupAnim"];
    item.center = item.startPoint;
    for (NSUInteger i = 0; i < self.itemsArray.count; i ++) {
        ICDExpandingItem *otherItem = self.itemsArray[i];
        if (otherItem.tag == item.tag) {
            continue;
        }
        CAAnimationGroup *shrinkAnim = [self shrinkAnimationAtPoint:otherItem.center];
        [otherItem.layer addAnimation:shrinkAnim forKey:@"shrinkAnim"];
        otherItem.center = otherItem.startPoint;
    }

    _expanding = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.backgroundColor = UIColorFromRGBA(0xffffff, 0.0);
        self.centerButton.transform = CGAffineTransformMakeRotation(0.0f);
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(icdExpandingMenu:didSelectedAtIndex:)]) {
        [self.delegate icdExpandingMenu:self didSelectedAtIndex:self.selectedIndex];
    }
}

#pragma mark - private methods
- (void)didExpand {
    if (self.flag == self.itemsArray.count) {
        [self.timer invalidate];
        _timer = nil;
        return;
    }
    
    NSInteger tag = 1000 + self.flag;
    ICDExpandingItem *item = (ICDExpandingItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    [item.layer addAnimation:positionAnimation forKey:@"Expand"];
    
    item.center = item.endPoint;

    self.flag ++;
}

- (void)didClose {
    if (self.flag < 0) {
        [self.timer invalidate];
        self.timer = nil;
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundColor = UIColorFromRGBA(0xffffff, 0.0);
        }];
    }
    
    NSInteger tag = 1000 + self.flag;
    ICDExpandingItem *item = (ICDExpandingItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    [item.layer addAnimation:positionAnimation forKey:@"Close"];
    
    item.center = item.startPoint;
    
    self.flag --;
}

- (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

- (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

#pragma mark - setters
- (void)setExpanding:(BOOL)expanding {
    _expanding = expanding;
    
    if (_expanding) {
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundColor = UIColorFromRGBA(0xffffff, 1.0);
        }];
    }
    
    float angle = _expanding ? -M_PI_2 : 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        self.centerButton.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    if (!self.timer) {
        self.flag = _expanding ? 0 : self.itemsArray.count;
        SEL selector = _expanding ? @selector(didExpand) : @selector(didClose);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOFFSET target:self selector:selector userInfo:nil repeats:YES];
    }
}

- (void)setExpandingCenter:(CGPoint)expandingCenter {
    _expandingCenter = expandingCenter;
    
    [self setNeedsLayout];
}

- (void)setExpandingRadius:(CGFloat)expandingRadius {
    _expandingRadius = expandingRadius;
    
    [self setNeedsLayout];
}

- (void)setExpandingDirection:(ExpandingDirection)expandingDirection {
    _expandingDirection = expandingDirection;
    
    [self setNeedsLayout];
}
@end
