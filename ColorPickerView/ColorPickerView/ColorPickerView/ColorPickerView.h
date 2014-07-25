//
//  ColorPickerView.h
//  ColorPickerView
//
//  Created by Vols on 14-7-25.
//  Copyright (c) 2014年 Vols. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPickerView;
@protocol ColorPickerViewDelegate <NSObject>

- (void)colorPickerView:(ColorPickerView *)colorPickerView didSelectedColor:(UIColor *)color;

@end

@interface ColorPickerView : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<ColorPickerViewDelegate> delegate;

@property (nonatomic, assign) NSInteger colorsPerRow;
@property (nonatomic, assign) CGFloat colorCellPadding;
@property (nonatomic, assign) BOOL highlighting;
@property (nonatomic, strong) UIColor *selectionBorderColor;

-(void)setColors:(NSArray *)colors;  // Changes the colors displayed at the picker

@end
