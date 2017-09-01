//
//  ZBColorPicker.h
//  colorP
//
//  Created by Apple on 17/9/1.
//  Copyright © 2017年 XLKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBColorPicker;

@protocol ZBColorPickerDelegate <NSObject>
///颜色正在变化
- (void)colorPicker:(ZBColorPicker *)colorPicker colorDidChange:(UIColor *)color;
///颜色停止变化
- (void)colorPicker:(ZBColorPicker *)colorPicker colorEndChange:(UIColor *)color;

@end

@interface ZBColorPicker : UIView

@property (nonatomic, weak) id<ZBColorPickerDelegate> delegate;
///颜色亮度值 默认=1（范围0~1）
@property (nonatomic, assign) float brightness;

@end
