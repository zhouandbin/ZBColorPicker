//
//  ZBColorPicker.m
//  colorP
//
//  Created by Apple on 17/9/1.
//  Copyright © 2017年 XLKJ. All rights reserved.
//

#import "ZBColorPicker.h"

@interface ZBColorPicker ()

@property (nonatomic, strong) UIImageView *colorMap;

@property (nonatomic, strong) UIView *indicator;

@end

@implementation ZBColorPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    _brightness = 1.0;
    [self createColorMap];
    [self createIndicator];
    [self addObserver:self forKeyPath:@"brightness" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self getColorInPoint:_indicator.center withType:0];
}

- (void)createColorMap {
    _colorMap = [[UIImageView alloc]initWithFrame:self.bounds];
    _colorMap.layer.cornerRadius = self.frame.size.width / 2;
    _colorMap.layer.masksToBounds = YES;
    _colorMap.layer.borderWidth = 1.5;
    _colorMap.layer.borderColor = [UIColor blackColor].CGColor;
    [self addSubview:_colorMap];
    _colorMap.image = [self createMapImageWithView:_colorMap];
}

- (UIImage *)createMapImageWithView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat w = view.frame.size.width;
    CGPoint centerPoint = CGPointMake(w / 2, w / 2);
    
    for (int i = 0; i < view.frame.size.width; i++) {
        for (int j = view.frame.size.height; j > 0; j--) {
            
            CGFloat re = sqrt(pow(centerPoint.x - i, 2) + pow(centerPoint.y - j, 2));
            if (re <= w / 2) {
                double angle = atan2(i - centerPoint.x, j - centerPoint.y);
                if (angle < 0) angle += (M_PI) * 2;
                CGRect r =CGRectMake(i,view.frame.size.height - j, 1, 1);
                UIColor *color = [UIColor colorWithHue:angle / (M_PI * 2) saturation:re / (w / 2) brightness:1.0 alpha:1.0];
                CGContextSetFillColorWithColor(context, [color CGColor]);
                CGContextFillRect(context, r);
            }
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)createIndicator {
    _indicator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _indicator.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _indicator.backgroundColor = [UIColor whiteColor];
    _indicator.layer.cornerRadius = 15;
    _indicator.layer.masksToBounds = YES;
    _indicator.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _indicator.layer.borderWidth = 3;
    [self addSubview:_indicator];
}


- (void)getColorInPoint:(CGPoint)point withType:(NSInteger)type {
    point.y = self.frame.size.height - point.y;
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat re = sqrt(pow(centerPoint.x - point.x, 2) + pow(centerPoint.y - point.y, 2));
    double angle = atan2(point.x - centerPoint.x, point.y - centerPoint.y);
    if (angle < 0) angle += (M_PI) * 2;
    UIColor *color = [UIColor colorWithHue:angle / (M_PI * 2) saturation:re / (self.frame.size.width / 2) brightness:_brightness alpha:1.0];
    _indicator.backgroundColor = color;
    
    if (type == 0) {
        if ([self.delegate respondsToSelector:@selector(colorPicker:colorDidChange:)]) {
            [self.delegate colorPicker:self colorDidChange:color];
        }
    }
    
    if (type == 1) {
        if ([self.delegate respondsToSelector:@selector(colorPicker:colorEndChange:)]) {
            [self.delegate colorPicker:self colorEndChange:color];
        }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat w = self.frame.size.width;
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGFloat absX = ABS(center.x - point.x);
    CGFloat absY = ABS(center.y - point.y);
    
    CGFloat length = sqrt(absX * absX + absY * absY);
    
    if (length > (w / 2)) {
        CGFloat extra = length - (w / 2);
        CGFloat extraY = extra * (center.y - point.y) / length;
        CGFloat extraX = extra * (center.x - point.x) / length;
        
        point.x += extraX;
        point.y += extraY;
    }
    _indicator.center = point;

    [self getColorInPoint:point withType:1];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat w = self.frame.size.width;
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGFloat absX = ABS(center.x - point.x);
    CGFloat absY = ABS(center.y - point.y);
    
    CGFloat length = sqrt(absX * absX + absY * absY);
    
    if (length > (w / 2)) {
        CGFloat extra = length - (w / 2);
        CGFloat extraY = extra * (center.y - point.y) / length;
        CGFloat extraX = extra * (center.x - point.x) / length;
        
        point.x += extraX;
        point.y += extraY;
    }
    _indicator.center = point;
    
    [self getColorInPoint:point withType:0];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat w = self.frame.size.width;
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGFloat absX = ABS(center.x - point.x);
    CGFloat absY = ABS(center.y - point.y);
    
    CGFloat length = sqrt(absX * absX + absY * absY);
    
    if (length > (w / 2)) {
        CGFloat extra = length - (w / 2);
        CGFloat extraY = extra * (center.y - point.y) / length;
        CGFloat extraX = extra * (center.x - point.x) / length;
        
        point.x += extraX;
        point.y += extraY;
    }
    _indicator.center = point;
    
    [self getColorInPoint:point withType:1];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"brightness"];
}

@end
