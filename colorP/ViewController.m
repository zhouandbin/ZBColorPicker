//
//  ViewController.m
//  colorP
//
//  Created by Apple on 17/9/1.
//  Copyright © 2017年 XLKJ. All rights reserved.
//

#import "ViewController.h"
#import "ZBColorPicker.h"

@interface ViewController ()<ZBColorPickerDelegate>
@property (nonatomic, strong) ZBColorPicker *zbc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(20, 20, 250, 30)];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = 1.0;
    [slider addTarget:self action:@selector(valueChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:slider];
    
    ZBColorPicker *zbc = [[ZBColorPicker alloc]initWithFrame:CGRectMake(20, 50, 250, 250)];
    zbc.delegate = self;
    _zbc = zbc;
    [self.view addSubview:zbc];
}

- (void)valueChange:(UISlider *)slider {
    
    _zbc.brightness = slider.value;
}


- (void)colorPicker:(ZBColorPicker *)colorPicker colorDidChange:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)colorPicker:(ZBColorPicker *)colorPicker colorEndChange:(UIColor *)color {
    self.view.backgroundColor = color;
}

@end
