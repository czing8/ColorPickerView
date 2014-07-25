//
//  ViewController.m
//  ColorPickerView
//
//  Created by Vols on 14-7-25.
//  Copyright (c) 2014年 Vols. All rights reserved.
//

#import "ViewController.h"
#import "ColorPickerView.h"
#import "UIColor+extensions.h"

@interface ViewController () <ColorPickerViewDelegate> {
  NSInteger gridSize;
}

@property(nonatomic, strong) ColorPickerView *colorPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBar.translucent = NO;
  [self.view addSubview:self.colorPickerView];
  [self.colorPickerView setColors:[self createDemoColor]];

  gridSize = 4;

  UIBarButtonItem *changeGrid = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                           target:self
                           action:@selector(changeGridSize)];
  changeGrid.tintColor = [UIColor blackColor];

  self.navigationItem.rightBarButtonItem = changeGrid;
}

- (void)changeGridSize {
  gridSize++;

  if (gridSize > 10) {
    gridSize = 2;
  }

  _colorPickerView.colorsPerRow = gridSize;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  _colorPickerView.frame = self.view.bounds;
}

- (void)colorPickerView:(ColorPickerView *)colorPickerView
       didSelectedColor:(UIColor *)color {
  self.navigationController.navigationBar.barTintColor = color;
}

- (NSArray *)createDemoColor {
  NSMutableArray *colors = [[NSMutableArray alloc] init];

  NSInteger colorCount = 36;
  NSInteger createdColors = 0;
  CGFloat hueStep = 1.0 / colorCount;

  CGFloat currentHue = 0.0;

  while (createdColors < colorCount) {

    UIColor *tmpColor = [UIColor colorWithHue:currentHue
                                   saturation:1.0
                                   brightness:1.0
                                        alpha:1.0];
    [colors addObject:tmpColor];
    currentHue += hueStep;

    createdColors++;
  }

  return colors;
}

- (ColorPickerView *)colorPickerView {
  if (!_colorPickerView) {
    _colorPickerView = [[ColorPickerView alloc] init];

    _colorPickerView.delegate = self;

    _colorPickerView.colorsPerRow = 4;
    _colorPickerView.colorCellPadding = 2.0;

    _colorPickerView.highlighting = YES;
    _colorPickerView.selectionBorderColor = [UIColor whiteColor];
    _colorPickerView.backgroundColor = [UIColor colorWithHexString:@"1d2225"];
  }
  return _colorPickerView;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
