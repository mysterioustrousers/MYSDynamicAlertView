//
//  MYSTossAlertView.m
//  DynamicsPlayground
//
//  Created by Dan Willoughby on 6/4/14.
//  Copyright (c) 2014 Willoughby. All rights reserved.
//


typedef void (^ActionBlock)();
#define NILL(a) ([a isKindOfClass:[NSNull class]] ? nil : a) // swaps NSNull with nil
#define NUL(a) (a ?: [NSNull null]) // swaps nil with NSNull

#import "MYSDynamicAlertView.h"
#import "MYSBackDropView.h"
#import "MYSTouchScrollView.h"
#import "MYSContentView.h"


@interface MYSDynamicAlertView () <UIScrollViewDelegate, MYSTouchScrollViewDelegate>
@property (nonatomic, strong) UIDynamicAnimator   *animator;
@property (nonatomic, strong) UIWindow            *otherWindow;
@property (nonatomic, strong) NSMutableDictionary *blockDictionary;
@property (nonatomic, strong) MYSBackDropView     *backDropView;
@property (nonatomic, strong) MYSTouchScrollView  *touchScrollView;
@property (nonatomic, strong) MYSContentView      *contentView;
@property (nonatomic, assign) BOOL                isLaunching;
@end


@implementation MYSDynamicAlertView


- (void)show
{
    if (self.otherWindow == nil) {
        self.otherWindow                = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.otherWindow.windowLevel    = UIWindowLevelAlert;
        [self.otherWindow setRootViewController:self];
    }
    
    // size the alert view
    CGFloat viewWidth   = self.view.bounds.size.width;
    CGFloat viewHeight  = self.view.bounds.size.height;
    CGFloat width       = 0;
    CGFloat height      = 0;
    
    // TODO figure out better way to size 
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        width   = viewWidth  / 3;
        height  = viewHeight / 8;
    }
    else {
        width   = viewWidth - viewWidth * 0.15;
        height  = viewHeight / 4.5;
    }
    
    if (self.backDropView == nil) {
        self.backDropView = [[MYSBackDropView alloc] initWithFrame:CGRectMake(0, 0, width, height *2 - 4)]; // -4 so the backdrop won't be visable when scrolling back to the center
        [self.view addSubview:self.backDropView];
    }
    self.backDropView.isLaunching   = NO;
    self.backDropView.center        = self.view.center;
    [self.backDropView snapIn:NO];
    
    if (self.touchScrollView == nil) {
        self.touchScrollView = [[MYSTouchScrollView alloc] initWithFrame:self.view.bounds];
        self.touchScrollView.layer.cornerRadius = 15;
        [self.view addSubview:self.touchScrollView];
    }
    self.touchScrollView.delegate       = self;
    self.touchScrollView.touchDelegate  = self;
    self.touchScrollView.center         = self.view.center;
    
    if (self.contentView == nil) {
        self.contentView = [[MYSContentView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.contentView.layer.cornerRadius = 15;
        [self.view addSubview:self.contentView];
    }
    self.contentView.center             = self.view.center;
    self.touchScrollView.contentView    = self.contentView;
    
    [self.otherWindow makeKeyAndVisible];
    
    if (self.animator == nil) {
        self.animator           = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor =[UIColor colorWithWhite:0.0 alpha:0.4];
    }];
    
    
}

- (void)setDismissBlock:(void (^)(void))block direction:(MYSTossAlertViewDirection)direction
{
    if (direction > MYSTossAlertViewDirectionDown)
        direction = MYSTossAlertViewDirectionUp;
    
    self.blockDictionary[@(direction)] = NUL((id)block); // NUL so that the direction can exist as a key, keys are used to filter permitted dismiss directions
}

#pragma mark - MYSDynamicScrollViewDelegate

- (void)contentViewPressed:(id)sender
{
    [self.backDropView snapOut:YES];
}


- (void)contentViewEndTap:(id)sender
{
    [self.backDropView snapIn:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.backDropView snapOut:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.backDropView snapIn:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint viewCenter      = [self.otherWindow convertPoint:self.view.center fromView:self.view];
    CGPoint contentCenter   = [self.otherWindow convertPoint:self.touchScrollView.center fromView:self.touchScrollView];
    CGFloat offset          = contentCenter.y - viewCenter.y;
    
    if (!self.backDropView.isLaunching) {
        self.contentView.center             = CGPointMake(self.view.center.x, self.view.center.y + offset);
        self.backDropView.scrollViewOffset  = offset;
    }
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint viewCenter      = [self.otherWindow convertPoint:self.view.center fromView:self.view];
    CGPoint contentCenter   = [self.otherWindow convertPoint:self.touchScrollView.center fromView:self.touchScrollView];
    CGFloat offset          = contentCenter.y - viewCenter.y;
    if (self.backDropView.isReadyToLaunch) {
        [self launchWithoffset:offset];
    }
}

- (void)launchWithoffset:(CGFloat)offset
{
    [self.animator removeAllBehaviors];
    self.backDropView.isLaunching   = YES;
    UIPushBehavior *pushBehavior    = [[UIPushBehavior alloc] initWithItems:@[self.contentView] mode:UIPushBehaviorModeContinuous];
    pushBehavior.pushDirection      = CGVectorMake(0, pow(offset, 1.4) * -1);
    UIAttachmentBehavior *attach    = [[UIAttachmentBehavior alloc] initWithItem:self.contentView attachedToItem:self.backDropView];
    attach.frequency                = 5;
    
    __block BOOL isAttached             = NO;
    __weak MYSDynamicAlertView *bself   = self;
    pushBehavior.action = ^{
        CGPoint viewCenter      = [bself.view.window convertPoint:bself.view.center fromView:bself.view];
        CGPoint contentCenter   = [bself.view.window convertPoint:bself.contentView.center fromView:bself.view];
        BOOL isAboveCenter      = ((viewCenter.y - contentCenter.y) > 0);
        
        // Attach the backdrop to the contentView only after it has passed the backdrop on its way out.
        if (!CGRectIntersectsRect(bself.backDropView.frame, bself.contentView.frame) && ( (offset < 0 && !isAboveCenter) || (offset > 0 && isAboveCenter))) {
            if (!isAttached || ![bself.animator.behaviors containsObject:attach]) {
                [bself.animator addBehavior:attach];
                isAttached = YES;
            }
        }
        
        for (UIDynamicBehavior *behavior in bself.animator.behaviors) {
            for (UIView *view in [(UIPushBehavior *)behavior items]) {
                CGRect frameInWindow = [view.superview convertRect:view.frame toView:nil];
                if (CGRectIntersectsRect(frameInWindow, view.window.frame)) {
                    return;
                }
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            bself.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            // TODO There is a lot of memory being used, the problem is probably here
            [bself.animator removeAllBehaviors];
            bself.otherWindow = nil;
        }];
    };
    [self.animator addBehavior:pushBehavior];
    
    UIDynamicItemBehavior *dynamicBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.backDropView]];
    dynamicBehaviour.density                = 1;
    [self.animator addBehavior:dynamicBehaviour];
}




# pragma mark - Getters

- (NSMutableDictionary *)blockDictionary
{
    if (_blockDictionary == nil) {
        _blockDictionary = [[NSMutableDictionary alloc] init];
    }
    return _blockDictionary;
}




# pragma mark - Private

- (void)roundCorner:(UIView *)view corners:(UIRectCorner)corners
{
    UIBezierPath *maskPath;
    maskPath                = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                    byRoundingCorners: corners
                                                          cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = view.bounds;
    maskLayer.path          = maskPath.CGPath;
    view.layer.mask         = maskLayer;
}

@end
