//
//  ICDExpandingItem.m
//  ICDExpandingMenu
//
//  Created by wenky on 15/10/15.
//  Copyright (c) 2015年 wenky. All rights reserved.
//

#import "ICDExpandingItem.h"

static inline CGRect ScaleRect(CGRect rect, float n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}

@interface ICDExpandingItem ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ICDExpandingItem

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)img highlightedImage:(UIImage *)himg {
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:img];
        _imageView.highlightedImage = himg;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x2893ff);
        [self addSubview:_titleLabel];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imgWidth = self.imageView.image.size.width;
    CGFloat imgHeight = self.imageView.image.size.height;
    if (self.titleLabel.text.length == 0) {
        self.bounds = CGRectMake(0, 0, imgWidth, imgHeight);
    } else {
        self.bounds = CGRectMake(0, 0, imgWidth, imgHeight + 8 + 21);
    }
    self.imageView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    self.titleLabel.frame = CGRectMake(-10, imgHeight + 8, imgWidth + 20, 21);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.imageView.highlighted = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(icdExpandingItemTouchesBegan:)]) {
        [self.delegate icdExpandingItemTouchesBegan:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //如果移动后不在2倍item大小范围，则高亮状态消失
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(ScaleRect(self.bounds, 2.0), location)) {
        self.imageView.highlighted = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.imageView.highlighted = NO;
    //如果在2倍item大小范围内，则触发点击delegate
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(ScaleRect(self.bounds, 2.0), location)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(icdExpandingItemTouchesEnd:)]) {
            [self.delegate icdExpandingItemTouchesEnd:self];
        }
    }
}

@end
