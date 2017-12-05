//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGViewModeButton.h"

#import "NSBundle+SRGMediaPlayer.h"

#import <libextobjc/libextobjc.h>
#import <MAKVONotificationCenter/MAKVONotificationCenter.h>

static void commonInit(SRGViewModeButton *self);

@interface SRGViewModeButton ()

@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UIButton *fakeInterfaceBuilderButton;

@end

@implementation SRGViewModeButton

#pragma mark Class methods

+ (SRGMediaPlayerViewMode)nextSupportedViewModeForMediaPlayerView:(SRGMediaPlayerView *)mediaPlayerView
{
    if (mediaPlayerView.supportedViewModes.count < 2) {
        return nil;
    }
    
    NSUInteger index = [mediaPlayerView.supportedViewModes indexOfObject:mediaPlayerView.viewMode];
    NSUInteger nextIndex = (index < mediaPlayerView.supportedViewModes.count - 1) ? index + 1 : 0;
    return mediaPlayerView.supportedViewModes[nextIndex];
}

#pragma mark Object lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        commonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        commonInit(self);
    }
    return self;
}

- (void)dealloc
{
    self.mediaPlayerView = nil;     // Unregister everything
}

#pragma mark Getters and setters

- (void)setMediaPlayerView:(SRGMediaPlayerView *)mediaPlayerView
{
    [_mediaPlayerView removeObserver:self keyPath:@keypath(mediaPlayerView.supportedViewModes)];
    
    _mediaPlayerView = mediaPlayerView;
    [self updateAppearanceForMediaPlayerView:mediaPlayerView];
    
    @weakify(mediaPlayerView)
    [mediaPlayerView addObserver:self keyPath:@keypath(_mediaPlayerView.supportedViewModes) options:0 block:^(MAKVONotification *notification) {
        @strongify(mediaPlayerView)
        [self updateAppearanceForMediaPlayerView:mediaPlayerView];
    }];
}

- (UIImage *)viewModeFlatImage
{
    return _viewModeFlatImage ?: [UIImage imageNamed:@"view_mode_flat" inBundle:[NSBundle srg_mediaPlayerBundle] compatibleWithTraitCollection:nil];
}

- (UIImage *)viewMode360Image
{
    return _viewMode360Image ?: [UIImage imageNamed:@"view_mode_360" inBundle:[NSBundle srg_mediaPlayerBundle] compatibleWithTraitCollection:nil];
}

- (UIImage *)viewModeStereoscopicImage
{
    return _viewModeStereoscopicImage ?: [UIImage imageNamed:@"view_mode_stereoscopic" inBundle:[NSBundle srg_mediaPlayerBundle] compatibleWithTraitCollection:nil];
}

- (void)setAlwaysHidden:(BOOL)alwaysHidden
{
    _alwaysHidden = alwaysHidden;
    [self updateAppearance];
}

#pragma mark Overrides

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    if (newWindow) {
        [self updateAppearance];
    }
}

- (CGSize)intrinsicContentSize
{
    if (self.fakeInterfaceBuilderButton) {
        return self.fakeInterfaceBuilderButton.intrinsicContentSize;
    }
    else {
        return super.intrinsicContentSize;
    }
}

#pragma mark UI

- (void)updateAppearance
{
    return [self updateAppearanceForMediaPlayerView:self.mediaPlayerView];
}

- (void)updateAppearanceForMediaPlayerView:(SRGMediaPlayerView *)mediaPlayerView
{
    if (self.alwaysHidden) {
        self.hidden = YES;
    }
    else if (mediaPlayerView.supportedViewModes.count > 1) {
        SRGMediaPlayerViewMode nextViewMode = [SRGViewModeButton nextSupportedViewModeForMediaPlayerView:mediaPlayerView];
        if ([nextViewMode isEqualToString:SRGMediaPlayerViewMode360]) {
            [self.button setImage:self.viewMode360Image forState:UIControlStateNormal];
        }
        else if ([nextViewMode isEqualToString:SRGMediaPlayerViewModeStereoscopic]) {
            [self.button setImage:self.viewModeStereoscopicImage forState:UIControlStateNormal];
        }
        else {
            [self.button setImage:self.viewModeFlatImage forState:UIControlStateNormal];
        }
        self.hidden = NO;
    }
    else if (self.fakeInterfaceBuilderButton) {
        self.hidden = NO;
    }
    else {
        self.hidden = YES;
    }
}

#pragma mark Actions

- (void)srg_viewModeButton_toggleViewMode:(id)sender
{
    // TODO: Proper implementation
    if ([self.mediaPlayerView.viewMode isEqualToString:SRGMediaPlayerViewMode360]) {
        self.mediaPlayerView.viewMode = SRGMediaPlayerViewModeStereoscopic;
    }
    else if ([self.mediaPlayerView.viewMode isEqualToString:SRGMediaPlayerViewModeStereoscopic]) {
        self.mediaPlayerView.viewMode = SRGMediaPlayerViewMode360;
    }
}

#pragma mark Interface Builder integration

- (void)prepareForInterfaceBuilder
{
    // See comment in `-[SRGPictureInPictureButton prepareForInterfaceBuilder]`
    UIButton *fakeInterfaceBuilderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    fakeInterfaceBuilderButton.frame = self.bounds;
    fakeInterfaceBuilderButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [fakeInterfaceBuilderButton setImage:self.viewMode360Image forState:UIControlStateNormal];
    [self addSubview:fakeInterfaceBuilderButton];
    self.fakeInterfaceBuilderButton = fakeInterfaceBuilderButton;
    
    // Hide the normal button
    self.button.hidden = YES;
}

#pragma mark Accessibility

- (BOOL)isAccessibilityElement
{
    return YES;
}

- (NSString *)accessibilityLabel
{
    // TODO:
    return nil;
}

- (UIAccessibilityTraits)accessibilityTraits
{
    return UIAccessibilityTraitButton;
}

- (NSArray *)accessibilityElements
{
    return nil;
}

@end

static void commonInit(SRGViewModeButton *self)
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [button addTarget:self action:@selector(srg_viewModeButton_toggleViewMode:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.button = button;
    
    self.hidden = YES;
}
