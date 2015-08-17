//
//  PSPageControl.h
//  PSPageControl
//
//  Created by Piotr Sochalewski on 14.08.2015.
//  Copyright (c) 2015 Piotr Sochalewski. All rights reserved.
//

@import UIKit;

@interface PSPageControl : UIView

@property (strong, nonatomic) UIImage *backgroundPicture;
@property (strong, nonatomic) NSArray *views;
@property (assign, nonatomic) NSUInteger offsetPerPageInPixels;
@property (strong, nonatomic) UIColor *pageIndicatorTintColor;
@property (strong, nonatomic) UIColor *currentPageIndicatorTintColor;

@end
