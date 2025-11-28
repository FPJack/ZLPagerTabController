// ZLParallaxHeader.m
//
// Copyright (c) 2019 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <objc/runtime.h>
#import "ZLParallaxHeader.h"

@interface GMParallaxView : UIView
@property (nonatomic,weak) ZLParallaxHeader *parent;
@end

@implementation GMParallaxView

static void * const kZLParallaxHeaderKVOContext = (void*)&kZLParallaxHeaderKVOContext;

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self.parent forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kZLParallaxHeaderKVOContext];
    }
}

- (void)didMoveToSuperview{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview addObserver:self.parent
                         forKeyPath:NSStringFromSelector(@selector(contentOffset))
                            options:NSKeyValueObservingOptionNew
                            context:kZLParallaxHeaderKVOContext];
    }
}

@end

@interface ZLParallaxHeader ()
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSLayoutConstraint *positionConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation ZLParallaxHeader {
    BOOL _isObserving;
}

@synthesize contentView = _contentView;

#pragma mark Properties

- (UIView *)contentView {
    if (!_contentView) {
        GMParallaxView *contentView = [GMParallaxView new];
        contentView.parent = self;
        contentView.clipsToBounds = YES;
        contentView.translatesAutoresizingMaskIntoConstraints = NO;

        _heightConstraint = [contentView.heightAnchor constraintEqualToConstant:0];

        _contentView = contentView;
    }
    return _contentView;
}

- (void)setView:(UIView *)view {
    if (view != _view) {
        [_view removeFromSuperview];
        _view = view;

        [self updateConstraints];

        [self.contentView layoutIfNeeded];

        self.height = self.contentView.frame.size.height;
        self.heightConstraint.constant = self.height;
        self.heightConstraint.active = YES;
    }
}

- (void)setMode:(ZLParallaxHeaderMode)mode {
    if (_mode != mode) {
        _mode = mode;
        [self updateConstraints];
    }
}

- (void)setHeight:(CGFloat)height {
    if (_height != height) {

        //Adjust content inset
        [self adjustScrollViewTopInset:self.scrollView.contentInset.top - _height + height];

        _height = height;

        self.heightConstraint.constant = height;
        self.heightConstraint.active = YES;
        [self layoutContentView];
    }
}
- (void)setMinimumHeight:(CGFloat)minimumHeight {
    _minimumHeight = minimumHeight;
    [self layoutContentView];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _scrollView = scrollView;
        _isObserving = YES;
    }
}

- (void)setProgress:(CGFloat)progress {
    if(_progress != progress) {
        _progress = progress;

        if ([self.delegate respondsToSelector:@selector(parallaxHeaderDidScroll:)]) {
            [self.delegate parallaxHeaderDidScroll:self];
        }
    }
}

- (void)loadWithNibName:(NSString *)name bundle:(nullable NSBundle *)bundleOrNil options:(nullable NSDictionary<UINibOptionsKey, id> *)optionsOrNil {
    UINib *nib = [UINib nibWithNibName:name bundle:bundleOrNil];
    [nib instantiateWithOwner:self options:optionsOrNil];
}

#pragma mark Constraints

- (void)updateConstraints {
    if (!self.view) return;

    [self.contentView removeFromSuperview];
    [self.scrollView addSubview:self.contentView];

    [self.view removeFromSuperview];
    [self.contentView addSubview:self.view];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    switch (self.mode) {
        case ZLParallaxHeaderModeFill:
            [self setFillModeConstraints];
            break;

        case ZLParallaxHeaderModeTopFill:
            [self setTopFillModeConstraints];
            break;

        case ZLParallaxHeaderModeTop:
            [self setTopModeConstraints];
            break;

        case ZLParallaxHeaderModeBottom:
            [self setBottomModeConstraints];
            break;

        default:
            [self setCenterModeConstraints];
            break;
    }

    [self setContentViewConstraints];
}

- (void)setCenterModeConstraints {
    [self.view.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [self.view.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.view.heightAnchor constraintEqualToConstant:self.height].active = YES;
}

- (void)setFillModeConstraints {
    [self.view.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [self.view.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
}

- (void)setTopFillModeConstraints {
    [self.view.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [self.view.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.view.heightAnchor constraintGreaterThanOrEqualToConstant:self.height].active = YES;

    NSLayoutConstraint *constraint = [self.view.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor];
    constraint.priority = UILayoutPriorityDefaultHigh;
    constraint.active = YES;
}

- (void)setTopModeConstraints {
    [self.view.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [self.view.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.view.heightAnchor constraintEqualToConstant:self.height].active = YES;
}

- (void)setBottomModeConstraints {
    [self.view.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.view.heightAnchor constraintEqualToConstant:self.height].active = YES;
}

- (void)setContentViewConstraints {
    [self.contentView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor].active = YES;
    ///    ///适配阿拉伯语言会不显示

//    [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
    [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;

    self.positionConstraint = [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor];
    self.positionConstraint.active = YES;
}

#pragma mark Private Methods

- (void)layoutContentView {
    CGFloat minimumHeight = MIN(self.minimumHeight, self.height);
    CGFloat relativeYOffset = self.scrollView.contentOffset.y + self.scrollView.contentInset.top - self.height;
    CGFloat relativeHeight  = -relativeYOffset;
    self.positionConstraint.constant = relativeYOffset;
    self.heightConstraint.constant = MAX(relativeHeight, minimumHeight);
    //ScrollView刷新的时候把这行注释
    if (!self.scrollView.bounces) {//刷新topInset变化跳动的问题
       [self.contentView layoutSubviews];
    }
    CGFloat div = self.height - self.minimumHeight;
    self.progress = (self.contentView.frame.size.height - self.minimumHeight) / (div? : self.height);
}

- (void)adjustScrollViewTopInset:(CGFloat)top {
    UIEdgeInsets inset = self.scrollView.contentInset;

    //Adjust content offset
    CGPoint offset = self.scrollView.contentOffset;
    offset.y += inset.top - top;
    self.scrollView.contentOffset = offset;

    //Adjust content inset
    inset.top = top;
    self.scrollView.contentInset = inset;
}

#pragma mark KVO

//This is where the magic happens...
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (context == kZLParallaxHeaderKVOContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
            [self layoutContentView];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

@implementation UIScrollView (ZLParallaxHeader)

- (ZLParallaxHeader *)parallaxHeader {
    ZLParallaxHeader *parallaxHeader = objc_getAssociatedObject(self, @selector(parallaxHeader));
    if (!parallaxHeader) {
        parallaxHeader = [ZLParallaxHeader new];
        [self setParallaxHeader:parallaxHeader];
    }
    return parallaxHeader;
}

- (void)setParallaxHeader:(ZLParallaxHeader *)parallaxHeader {
    parallaxHeader.scrollView = self;
    objc_setAssociatedObject(self, @selector(parallaxHeader), parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
