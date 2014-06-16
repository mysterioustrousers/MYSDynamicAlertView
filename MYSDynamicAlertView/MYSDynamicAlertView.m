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


@interface MYSDynamicAlertView ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIWindow *otherWindow;
@property (nonatomic, strong) NSMutableDictionary *blockDictionary;
@property (nonatomic, assign) CGFloat speedLimit; // velocity needed to cause dismissal
@property (nonatomic, assign) CGFloat angleDegreeAllowance; // E.g. angleAllowance = 30 gestures in the left direction will be dimissed at 180 degrees +/- 30
@end


@implementation MYSDynamicAlertView


- (void)show
{
    self.otherWindow                = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.otherWindow.windowLevel    = UIWindowLevelAlert;
    [self.otherWindow setRootViewController:self];
    
    self.angleDegreeAllowance   = 35;
    self.speedLimit             = 800;
    
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
    
    
    // randomly snap in.
    int N   = viewWidth * 4;
    int r   = arc4random_uniform(N) - viewWidth * 2;
    
    UIView *viewToDrag = [[UIView alloc] initWithFrame:CGRectMake(r, -self.view.bounds.size.height, width, height)];
    viewToDrag.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self roundCorner:viewToDrag corners:UIRectCornerAllCorners];
    [self.view addSubview:viewToDrag];
    
    // Top
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(viewToDrag.bounds.size.width/2, viewToDrag.bounds.origin.y, 15, 20)];
    label.text = @"^";
    [viewToDrag addSubview:label];
    // Left
    label = [[UILabel alloc] initWithFrame:CGRectMake(viewToDrag.bounds.origin.x, viewToDrag.bounds.size.height/2 - 10,15, 20)];
    label.text = @"<";
    [viewToDrag addSubview:label];
    // Right
    label = [[UILabel alloc] initWithFrame:CGRectMake(viewToDrag.bounds.size.width - 15, viewToDrag.bounds.size.height/2 -10,15, 20)];
    label.text = @">";
    [viewToDrag addSubview:label];
    // Down
    label = [[UILabel alloc] initWithFrame:CGRectMake(viewToDrag.bounds.size.width/2, viewToDrag.bounds.size.height - 20,15, 20)];
    label.text = @"v";
    [viewToDrag addSubview:label];
    
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [viewToDrag addGestureRecognizer:pan];
    
    [self.otherWindow makeKeyAndVisible];
    
    self.animator           = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UISnapBehavior *snap    = [[UISnapBehavior alloc] initWithItem:viewToDrag snapToPoint:self.view.center];
    [self.animator addBehavior:snap];
    
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





# pragma mark - Getters

- (NSMutableDictionary *)blockDictionary
{
    if (_blockDictionary == nil) {
        _blockDictionary = [[NSMutableDictionary alloc] init];
    }
    return _blockDictionary;
}




# pragma mark - Private

- (void)addLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor redColor];
    label.text = @"<";
    [self.view addSubview:label];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    // adapted from http://stackoverflow.com/questions/21325057/implement-uikitdynamics-for-dragging-view-off-screen
    
    static UIAttachmentBehavior *attachment;
    static CGPoint               startCenter;
    
    // variables for calculating angular velocity
    
    static CFAbsoluteTime        lastTime;
    static CGFloat               lastAngle;
    static CGFloat               angularVelocity;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        [self.animator removeAllBehaviors];
        
        startCenter = gesture.view.superview.center;
        
        // calculate the center offset and anchor point
        CGPoint pointWithinAnimatedView = [gesture locationInView:gesture.view];
        UIOffset offset                 = UIOffsetMake(pointWithinAnimatedView.x - gesture.view.bounds.size.width / 2.0,
                                                       pointWithinAnimatedView.y - gesture.view.bounds.size.height / 2.0);
        
        CGPoint anchor                  = [gesture locationInView:gesture.view.superview];
        
        // create attachment behavior
        attachment = [[UIAttachmentBehavior alloc] initWithItem:gesture.view
                                               offsetFromCenter:offset
                                               attachedToAnchor:anchor];
        
        // code to calculate angular velocity (seems curious that I have to calculate this myself, but I can if I have to)
        lastTime    = CFAbsoluteTimeGetCurrent();
        lastAngle   = [self angleOfView:gesture.view];
        
        attachment.action = ^{
            CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
            CGFloat angle       = [self angleOfView:gesture.view];
            if (time > lastTime) {
                angularVelocity = (angle - lastAngle) / (time - lastTime);
                lastTime        = time;
                lastAngle       = angle;
            }
        };
        
        [self.animator addBehavior:attachment];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // as user makes gesture, update attachment behavior's anchor point, achieving drag 'n' rotate
        CGPoint anchor          = [gesture locationInView:gesture.view.superview];
        attachment.anchorPoint  = anchor;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.animator removeAllBehaviors];
        
        int left            = 180;
        int up              = 90;
        int down            = 270;
        int right           = 0;
        
        CGPoint velocity    = [gesture velocityInView:gesture.view.superview];
        double angle        = atan2(velocity.y, velocity.x) * -180.0f / 3.14159f;       // just use degrees
        if (angle < 0) angle += 360.0f;
        
        // if there direction enum exists in the dictionary allow it to be dismissed that direction
        BOOL isLeft     = (angle <= left + self.angleDegreeAllowance) && (angle > left - self.angleDegreeAllowance) && self.blockDictionary[@(MYSTossAlertViewDirectionLeft)];
        BOOL isUp       = (angle <= up + self.angleDegreeAllowance) && (angle > up - self.angleDegreeAllowance) && self.blockDictionary[@(MYSTossAlertViewDirectionUp)];;
        BOOL isDown     = (angle <= down + self.angleDegreeAllowance) && (angle > down - self.angleDegreeAllowance) && self.blockDictionary[@(MYSTossAlertViewDirectionDown)];
        BOOL isRight    = (((angle <= right + self.angleDegreeAllowance) && (angle >= right)) || (angle > right + 360 - self.angleDegreeAllowance)) && self.blockDictionary[@(MYSTossAlertViewDirectionRight)];
        
        //NSLog(@"angle: %f right: %d left: %d up: %d down: %d", angle, isRight, isLeft, isUp, isDown);
        
        // snap it back if it doesn't match the direction restraints
        if ((!isLeft && !isRight && !isUp && !isDown) || (fabs(velocity.x) < self.speedLimit && (isRight || isLeft)) || (fabs(velocity.y) < self.speedLimit && (isUp || isDown))) {
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
            [self.animator addBehavior:snap];
            [UIView animateWithDuration:0.3 animations:^{
                self.view.backgroundColor =[UIColor colorWithWhite:0.0 alpha:0.4];
            }];
            return;
        }
        
        // otherwise, create UIDynamicItemBehavior that carries on animation from where the gesture left off (notably linear and angular velocity)
        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[gesture.view]];
        [dynamic addLinearVelocity:velocity forItem:gesture.view];
        [dynamic addAngularVelocity:angularVelocity forItem:gesture.view];
        [dynamic setAngularResistance:2];
        
        // add a push so it accelerates off the screen (in case user gesture was slow)
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[gesture.view] mode:UIPushBehaviorModeContinuous];
        push.pushDirection = CGVectorMake(velocity.x * 0.3, velocity.y * 0.3);
        [self.animator addBehavior:push];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.backgroundColor = [UIColor clearColor];
        }];
        
        NSNumber *key = nil;
        if (isRight)
            key = @(MYSTossAlertViewDirectionRight);
        else if (isLeft)
            key = @(MYSTossAlertViewDirectionLeft);
        else if (isUp)
            key = @(MYSTossAlertViewDirectionUp);
        else if (isDown)
            key = @(MYSTossAlertViewDirectionDown);
        
        ActionBlock block   = NILL(self.blockDictionary[key]);
        
        // when the view no longer intersects with its superview, go ahead and remove it
        dynamic.action = ^{
            if (!CGRectIntersectsRect(gesture.view.superview.bounds, gesture.view.frame)) {
                [self.animator removeAllBehaviors];
                [gesture.view removeFromSuperview];
                self.otherWindow.hidden             = YES;
                self.otherWindow                    = nil;
                if (block) block();
            }
        };
        [self.animator addBehavior:dynamic];
    }
}

- (CGFloat)angleOfView:(UIView *)view
{
    // http://stackoverflow.com/a/2051861/1271826
    
    return atan2(view.transform.b, view.transform.a);
}

- (void)roundCorner:(UIView *)view corners:(UIRectCorner)corners
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners: corners
                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = view.bounds;
    maskLayer.path          = maskPath.CGPath;
    view.layer.mask         = maskLayer;
}

@end
