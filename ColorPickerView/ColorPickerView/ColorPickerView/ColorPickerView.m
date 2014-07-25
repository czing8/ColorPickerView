//
//  ColorPickerView.m
//  ColorPickerView
//
//  Created by Vols on 14-7-25.
//  Copyright (c) 2014年 Vols. All rights reserved.
//

#import "ColorPickerView.h"


#define kDefaultCellPadding 2.0f

#define kColorCellIdentifier @"CHColorPickerViewColorCellReuseIdentifier"

@interface ColorPickerView ()

//current selected color
@property (nonatomic, strong) UIColor * selectedColor;

@property (nonatomic, strong) NSArray * colors;
@property (nonatomic, strong) UICollectionView *colorCollectionView;

@end


@implementation ColorPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInitialization];
    }
    return self;
}



- (id)init
{
    self = [super init];
    if (self) {
        [self doInitialization];
    }
    return self;
}


#pragma mark - setters

-(void)setColors:(NSArray *)colorsIn{
    _colors = nil;
    _colors = colorsIn;
    
    [self resetColorPicker];
}

-(void)setColorsPerRow:(NSInteger)colorsPerRow{
    if (colorsPerRow < 1) {
        
        _colorsPerRow = 1;
        [self resetColorPicker];
        return;
    }
    _colorsPerRow = colorsPerRow;
    
    [self resetColorPicker];
}

-(void)setColorCellPadding:(CGFloat)colorCellPadding
{
    _colorCellPadding = colorCellPadding;
    
    if (_colorCellPadding < 0.0) {
        _colorCellPadding = 0.0;
    }
    
    [self resetColorPicker];
}

-(void)setHighlightSelection:(BOOL)highlighting
{
    _highlighting = highlighting;
    
    [self resetColorPicker];
}

-(void)setSelectionBorderColor:(UIColor *)selectionBorderColor
{
    _selectionBorderColor = selectionBorderColor;
    
    [self resetColorPicker];
}

- (UICollectionView *)colorCollectionView{
    if (!_colorCollectionView) {
        _colorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        [_colorCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kColorCellIdentifier];
        _colorCollectionView.scrollEnabled = YES;
        _colorCollectionView.alwaysBounceVertical = YES;
        _colorCollectionView.backgroundColor = [UIColor clearColor];
        
        _colorCollectionView.contentInset = UIEdgeInsetsMake(_colorCellPadding, 0, _colorCellPadding, 0);
        
        _colorCollectionView.delegate = self;
        _colorCollectionView.dataSource = self;
        
    }
    return _colorCollectionView;
}


-(void)layoutSubviews
{
    _colorCollectionView.frame = self.bounds;
}


#pragma mark - privates

-(void)doInitialization
{
    self.colorsPerRow = 4;
    _colorCellPadding = kDefaultCellPadding;
    _highlighting = YES;
    _selectionBorderColor = [UIColor whiteColor];
    
    [self addSubview:self.colorCollectionView];
}

-(void)setColorCell:(UICollectionViewCell *)cell selected:(BOOL)selected
{
    
    if (!selected || !_highlighting) {
        cell.contentView.layer.borderColor = nil;
        cell.contentView.layer.borderWidth = 0;
    }else {
        cell.contentView.layer.borderColor = _selectionBorderColor.CGColor;
        cell.contentView.layer.borderWidth = 5;
    }
}

-(void)resetColorPicker
{
    [_colorCollectionView setContentOffset:CGPointMake(0, 0)];
    [_colorCollectionView reloadData];
}


#pragma mark - Collection View Delegate and DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _colors.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell;
    
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kColorCellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    
    [self setColorCell:cell selected:cell.isSelected];

    cell.backgroundColor = [_colors objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_colorCollectionView cellForItemAtIndexPath:indexPath];
    
    cell.alpha = 0.9;
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_colorCollectionView cellForItemAtIndexPath:indexPath];
    
    cell.alpha = 1.0;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setColorCell:[collectionView cellForItemAtIndexPath:indexPath] selected:YES];
    
    _selectedColor = [_colors objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerView:didSelectedColor:)]) {
        [self.delegate colorPickerView:self didSelectedColor:_selectedColor];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setColorCell:[collectionView cellForItemAtIndexPath:indexPath] selected:NO];
}

#pragma mark - CollectionView Layout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger itemsPerRow = _colorsPerRow;
    NSInteger spaceMultiplier = (itemsPerRow-1)*_colorCellPadding;
    
    if (spaceMultiplier <= 0) {
        spaceMultiplier = 0;
    }
    
    CGFloat size = floorf((collectionView.bounds.size.width-spaceMultiplier)/itemsPerRow);
    
    return CGSizeMake(size, size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return _colorCellPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return _colorCellPadding;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,0,0,0);
}


@end
