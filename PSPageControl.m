//
//  PSPageControl.m
//  PSPageControl
//
//  Created by Piotr Sochalewski on 14.08.2015.
//  Copyright (c) 2015 Piotr Sochalewski. All rights reserved.
//

#import "PSPageControl.h"

@interface PSPageControl ()

#pragma mark - Properties
#pragma mark Main properties
@property (strong, nonatomic) NSArray *subviewsNotAllowedToRemoveFromSuperview;
@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UIPageControl *pageControl;

#pragma mark Touch properties
@property (assign, nonatomic) CGPoint touchPosition;
@property (assign, nonatomic) NSInteger currentViewIndex;
@property (assign, nonatomic) CGPoint backgroundLayerFrameOrigin;

@end

@implementation PSPageControl

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    // Default values
    self.offsetPerPageInPixels = 40;
    self.currentViewIndex = 0;
    
    // Background image
    self.background = [UIImageView new];
    self.background.contentMode = UIViewContentModeLeft;
    [self addSubview:self.background];
    
    // Page control
    self.pageControl = [UIPageControl new];
    self.pageControl.numberOfPages = self.views.count;
    [self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
    // Array of views not allowed to remove from superview
    self.subviewsNotAllowedToRemoveFromSuperview = @[self.background, self.pageControl];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Backround image
    self.background.frame = self.frame;
    self.background.layer.frame = CGRectMake(-(NSInteger)self.offsetPerPageInPixels, 0, CGRectGetWidth(self.background.layer.frame), CGRectGetHeight(self.background.layer.frame));
    self.backgroundLayerFrameOrigin = self.background.layer.frame.origin;
    
    //Page control
    self.pageControl.frame = CGRectMake(10, CGRectGetHeight(self.frame)-50, CGRectGetWidth(self.frame)-20, 40);
}

#pragma mark - Setters

- (void)setBackgroundPicture:(UIImage *)backgroundPicture {
    _backgroundPicture = backgroundPicture;
    
    CGSize size = AVMakeRectWithAspectRatioInsideRect(backgroundPicture.size, CGRectMake(0, 0, CGFLOAT_MAX, CGRectGetHeight(self.frame))).size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [backgroundPicture drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.background.image = image;
}

- (void)setViews:(NSArray *)views {
    _views = views;
    
    for (UIView *subview in self.subviews) {
        if (![self.subviewsNotAllowedToRemoveFromSuperview containsObject:subview]) {
            [subview removeFromSuperview];
        }
    }
    
    for (NSUInteger i = 0; i < views.count; i++) {
        UIView *view = (UIView *)views[i];
        view.frame = CGRectMake(i*CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [self addSubview:view];
    }
    
    [self bringSubviewToFront:self.pageControl];
    self.pageControl.numberOfPages = self.views.count;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

#pragma mark - Views

- (void)setVisibleViewWithIndex:(NSInteger)index setCurrentPage:(BOOL)setCurrentPage {
    // Background image
    if (index != self.currentViewIndex) {
        CGFloat newX = (index > self.currentViewIndex) ? self.backgroundLayerFrameOrigin.x-self.offsetPerPageInPixels : self.backgroundLayerFrameOrigin.x+self.offsetPerPageInPixels;
        self.backgroundLayerFrameOrigin = CGPointMake(newX, 0);
    }
    
    [UIView animateWithDuration:(index == self.currentViewIndex) ? 0.3 : 0.2 animations:^{
        self.background.layer.frame = CGRectMake(self.backgroundLayerFrameOrigin.x, 0, CGRectGetWidth(self.background.layer.frame), CGRectGetHeight(self.background.layer.frame));
    }];
    
    // Views
    [UIView animateWithDuration:0.2 animations:^{
        // Center (show) view with current index
        UIView *view = (UIView *)self.views[index];
        view.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        // Move to the left views with index lower than >index<
        for (NSInteger i = 0; i < index; i++) {
            UIView *view = (UIView *)self.views[i];
            view.frame = CGRectMake(-(index-i)*CGRectGetWidth(self.frame), 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        }
        
        // Move to the right view with index higher than >index<
        for (NSInteger i = index+1; i < self.views.count; i++) {
            UIView *view = (UIView *)self.views[i];
            view.frame = CGRectMake((i-index)*CGRectGetWidth(self.frame), 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        }
    } completion:^(BOOL finished) {
        if (setCurrentPage) {
            self.pageControl.currentPage = index;
        }
        self.currentViewIndex = index;
    }];
}

#pragma mark - Math

- (NSInteger)differenceBetweenStartPosition:(CGPoint)startPosition andCurrentPosition:(CGPoint)currentPosition {
    return (currentPosition.x - startPosition.x);
}

- (NSInteger)differenceFromTouches:(NSSet *)touches {
    CGPoint movingPosition = [touches.anyObject locationInView:self];
    
    return [self differenceBetweenStartPosition:self.touchPosition andCurrentPosition:movingPosition];
}

#pragma mark - Swipes

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    self.touchPosition = [touches.anyObject locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    NSInteger differenceInTouchXAxis = [self differenceFromTouches:touches];
    
    [UIView animateWithDuration:0.1 animations:^{
        for (NSInteger i = 0; i < self.views.count; i++) {
            UIView *view = (UIView *)self.views[i];
            view.frame = CGRectMake(((i-self.currentViewIndex)*CGRectGetWidth(view.frame))+differenceInTouchXAxis, CGRectGetMinY(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        }
        
        self.background.layer.frame = CGRectMake(self.backgroundLayerFrameOrigin.x + (differenceInTouchXAxis/CGRectGetWidth(self.frame))*self.offsetPerPageInPixels, 0, CGRectGetWidth(self.background.layer.frame), CGRectGetHeight(self.background.layer.frame));
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    NSInteger differenceInTouchXAxis = [self differenceFromTouches:touches];
    if (differenceInTouchXAxis < -100) {
        [self setVisibleViewWithIndex:((self.currentViewIndex+1 >= self.views.count) ? self.currentViewIndex : self.currentViewIndex+1) setCurrentPage:YES];
    } else if (differenceInTouchXAxis > 100) {
        [self setVisibleViewWithIndex:((self.currentViewIndex < 1) ? self.currentViewIndex : self.currentViewIndex-1) setCurrentPage:YES];
    } else {
        [self setVisibleViewWithIndex:self.currentViewIndex setCurrentPage:NO];
    }
}

#pragma mark - Page Control

- (void)pageControlValueChanged:(UIPageControl *)pageControl {
    [self setVisibleViewWithIndex:pageControl.currentPage setCurrentPage:NO];
}

@end
