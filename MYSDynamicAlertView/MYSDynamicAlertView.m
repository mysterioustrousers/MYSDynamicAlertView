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
@property (nonatomic, strong) NSMutableDictionary *titleDictionary;
@property (nonatomic, strong) MYSBackDropView     *backDropView;
@property (nonatomic, strong) MYSTouchScrollView  *touchScrollView;
@property (nonatomic, strong) MYSContentView      *contentView;
@property (nonatomic, assign) BOOL                isLaunching;
@property (nonatomic, strong) UIView              *topHalf;
@property (nonatomic, strong) UIView              *bottomHalf;

@end


@implementation MYSDynamicAlertView


- (void)show
{
    [self.view removeConstraints:self.view.constraints];
    
    if (self.otherWindow == nil) {
        self.otherWindow                    = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.otherWindow.backgroundColor    = [UIColor clearColor];
        self.otherWindow.windowLevel        = UIWindowLevelAlert;
        [self.otherWindow setRootViewController:self];
    }
    
    // size the alert view
    CGFloat width   = 270;
    CGFloat height  = 75;
    
    CGSize maximumSize              = CGSizeMake(width - 16, 9999);  // 16 for the edge inserts
    // header
    NSDictionary *stringAttributes  = [NSDictionary dictionaryWithObject:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] forKey: NSFontAttributeName];
    CGSize expectedLabelSize        = [self.alertTitle boundingRectWithSize:maximumSize
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:stringAttributes context:nil].size;
    height                         += expectedLabelSize.height;
    // body
    stringAttributes  = [NSDictionary dictionaryWithObject:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] forKey: NSFontAttributeName];
    expectedLabelSize        = [self.message boundingRectWithSize:maximumSize
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:stringAttributes context:nil].size;
    height                         += expectedLabelSize.height;
    
    if (self.backDropView == nil) {
        self.backDropView = [[MYSBackDropView alloc] init];
        [self.view addSubview:self.backDropView];
    }
    self.backDropView.isLaunching   = NO;
    [self centerView:self.backDropView withContantWidth:width height:height * 2- 4];// -4 so the backdrop won't be visable when scrolling back to the center
    [self.backDropView snapIn:NO];
    self.backDropView.upLabel.text = self.titleDictionary[@(MYSDynamicAlertViewDirectionUp)];
    self.backDropView.downLabel.text = self.titleDictionary[@(MYSDynamicAlertViewDirectionDown)];
    
    if (self.touchScrollView == nil) {
        self.touchScrollView = [[MYSTouchScrollView alloc] initWithFrame:self.view.bounds];
        self.touchScrollView.layer.cornerRadius = 15;
        [self.view addSubview:self.touchScrollView];
    }
    self.touchScrollView.delegate                               = self;
    self.touchScrollView.touchDelegate                          = self;
    UIView *touchScrollView                                     = self.touchScrollView;
    touchScrollView.translatesAutoresizingMaskIntoConstraints   = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[touchScrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(touchScrollView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[touchScrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(touchScrollView)]];
    
    if (self.contentView == nil) {
        self.contentView = [[MYSContentView alloc] init];
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.masksToBounds = YES;

        [self.view addSubview:self.contentView];
    }
    [self centerView:self.contentView withContantWidth:width height:height];
    self.touchScrollView.contentView    = self.contentView;
    self.contentView.messageLabel.text  = self.message;
    self.contentView.titleLabel.text    = self.alertTitle;
    
    
    [self sectionDetectionViews];
    [self.otherWindow makeKeyAndVisible];
    
    if (self.animator == nil) {
        self.animator           = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor =[UIColor colorWithWhite:0.0 alpha:0.7];
    }];
}

- (void)centerView:(UIView *)view withContantWidth:(CGFloat)width height:(CGFloat)height
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    // Width constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:width]];
    
    // Height constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:height]];
    
    // center x constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0 constant:0]];
    
    // center y constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0 constant:0]];
}

- (void)setTitle:(NSString *)title dismissBlock:(void (^)(void))block direction:(MYSDynamicAlertViewDirection)direction
{
    if (direction > MYSDynamicAlertViewDirectionDown)
        direction = MYSDynamicAlertViewDirectionUp;
    
    
    if (title != nil) {
        self.titleDictionary[@(direction)] = title;
    }
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
    CGFloat offset          = self.touchScrollView.contentOffset.y * -1;
    
    if (!self.backDropView.isLaunching) {
        self.contentView.center = CGPointMake(self.view.bounds.origin.x + self.view.bounds.size.width/2, self.view.bounds.origin.y + self.view.bounds.size.height/2 + offset);
    }
    if (self.touchScrollView.isDragging) {
        self.backDropView.scrollViewOffset  = offset;
    }
        self.contentView.scrollViewOffset   = offset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint viewCenter      = [self.otherWindow convertPoint:self.view.center fromView:self.view];
    CGPoint contentCenter   = [self.otherWindow convertPoint:self.touchScrollView.center fromView:self.touchScrollView];
    CGFloat offset          = contentCenter.y - viewCenter.y;
    if (self.backDropView.isReadyToLaunch) {
        [self launchWithoffset:offset direction:self.backDropView.direction];
    }
    else {
        [self.backDropView snapIn:YES];
    }
}

- (void)launchWithoffset:(CGFloat)offset direction:(MYSDynamicAlertViewDirection)direction
{
    [self.animator removeAllBehaviors];
    self.backDropView.isLaunching   = YES;
    UIPushBehavior *pushBehavior    = [[UIPushBehavior alloc] initWithItems:@[self.contentView] mode:UIPushBehaviorModeContinuous];
    double power                    = pow(fabs(offset), 1.6) * 0.4;
    if (direction == MYSDynamicAlertViewDirectionUp) {
        power *= -1;
    }

    pushBehavior.pushDirection      = CGVectorMake(0, power);
    UIAttachmentBehavior *attach    = [[UIAttachmentBehavior alloc] initWithItem:self.contentView attachedToItem:self.backDropView];
    attach.frequency                = 1;
    
     ActionBlock block   = NILL(self.blockDictionary[@(direction)]);
    
    __block BOOL isAttached             = NO;
    __weak MYSDynamicAlertView *bself   = self;
    pushBehavior.action = ^{
        CGRect contentFrame     = bself.contentView.frame;
        CGRect backDropFrame    = bself.backDropView.frame;
        
        BOOL isInTop            = CGRectContainsPoint(bself.topHalf.frame, bself.contentView.center);
        BOOL isInBottom         = CGRectContainsPoint(bself.bottomHalf.frame, bself.contentView.center);
        // Attach the backdrop to the contentView only after it has passed the backdrop on its way out.
        if (!CGRectIntersectsRect(backDropFrame, contentFrame) && ((direction == MYSDynamicAlertViewDirectionUp && !isInBottom) ||
            (direction == MYSDynamicAlertViewDirectionDown && !isInTop))) {
            if (!isAttached || ![bself.animator.behaviors containsObject:attach]) {
                [bself.animator addBehavior:attach];
                isAttached = YES;
            }
        }
        
        if (CGRectIntersectsRect([bself.view.superview convertRect:bself.backDropView.upLabel.frame fromView:bself.backDropView], bself.view.frame) && direction == MYSDynamicAlertViewDirectionUp) {
            return;
        }
        if (CGRectIntersectsRect([bself.view.superview convertRect:bself.backDropView.downLabel.frame fromView:bself.backDropView], bself.view.frame) && direction == MYSDynamicAlertViewDirectionDown) {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            bself.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [bself.animator removeAllBehaviors];
            if (block) block();
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bself.otherWindow = nil;
        });
    };
    [self.animator addBehavior:pushBehavior];
    
    UIDynamicItemBehavior *dynamicBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.backDropView]];
    dynamicBehaviour.density = 0.5;
    [self.animator addBehavior:dynamicBehaviour];
}




# pragma mark - Getters/Setters

- (NSMutableDictionary *)blockDictionary
{
    if (_blockDictionary == nil) {
        _blockDictionary = [[NSMutableDictionary alloc] init];
    }
    return _blockDictionary;
}

- (NSMutableDictionary *)titleDictionary
{
    if (_titleDictionary == nil) {
        _titleDictionary = [[NSMutableDictionary alloc] init];
    }
    return _titleDictionary;
}

- (void)setMessage:(NSString *)message
{
    _message                            = message;
    self.contentView.messageLabel.text  = message;
}

- (void)setTitle:(NSString *)title
{
    _alertTitle                         = title;
    self.contentView.titleLabel.text    = title;
}




# pragma mark - Private

- (void)sectionDetectionViews
{
    if (self.topHalf == nil) {
        self.topHalf = [[UIView alloc] init];
        self.topHalf.backgroundColor = [UIColor clearColor];
        self.topHalf.userInteractionEnabled = NO;
        [self.view addSubview:self.topHalf];
        self.topHalf.translatesAutoresizingMaskIntoConstraints = NO;
    }
    if (self.bottomHalf == nil) {
        self.bottomHalf = [[UIView alloc] init];
        self.bottomHalf.backgroundColor = [UIColor clearColor];
        self.bottomHalf.userInteractionEnabled = NO;
        [self.view addSubview:self.bottomHalf];
        self.bottomHalf.translatesAutoresizingMaskIntoConstraints = NO;
    }
    UIView *v       = self.bottomHalf;
    UIView *view    = self.topHalf;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(v)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(==v)]-[v]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, v)]];
}


@end
