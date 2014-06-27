//
//  MYSContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/17/14.
//
//

#define CHEVRON_WHITE 0.85
#define CHEVRON_WHITE_MAX 0.95
#define CHEVRON_WHITE_MIN 0.65

#import "MYSContentView.h"
#import "MYSDynamicAlertView.h"
#import "MYSChevronView.h"


@interface MYSContentView ()
@property (nonatomic, strong) MYSChevronView *topChevron;
@property (nonatomic, strong) MYSChevronView *bottomChevron;
@end


@implementation MYSContentView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        self.userInteractionEnabled = NO;                                               // scrollView deals with touches
        self.backgroundColor        = [UIColor groupTableViewBackgroundColor];
        
        CGFloat height = self.frame.size.height;
        
        self.titleLabel               = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]; // Also change font size of method that calculates height of title string in MYSDynamicAlertView
        
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.titleLabel];
        UILabel *titleLabel = self.titleLabel;
        
        
        self.messageLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,height/2)];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
        
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleBody]; // Also change font size of method that calculates height of message string in MYSDynamicAlertView
        
        [self.messageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.messageLabel];
        UILabel *messageLabel = self.messageLabel;
        
        self.topChevron = [[MYSChevronView alloc] init];
        self.topChevron.backgroundColor =  [UIColor clearColor];
        self.topChevron.direction = MYSDynamicAlertViewDirectionDown;
        self.topChevron.whiteColorLevel = CHEVRON_WHITE;
        [self addSubview:self.topChevron];
        
        self.bottomChevron = [[MYSChevronView alloc] init];
        self.bottomChevron.direction = MYSDynamicAlertViewDirectionUp;
        self.bottomChevron.whiteColorLevel = CHEVRON_WHITE;
        self.bottomChevron.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bottomChevron];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[titleLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[messageLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(messageLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[titleLabel(<=messageLabel)]-[messageLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,messageLabel)]];
        //[self.messageLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[messageLabel(200@300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(messageLabel)]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat chevViewWidth   = 50;
    CGFloat chevViewHeight  = 25;
    self.topChevron.frame   = CGRectMake(self.bounds.size.width/2 - chevViewWidth/2, self.bounds.origin.y, chevViewWidth, chevViewHeight);
    self.bottomChevron.frame= CGRectMake(self.bounds.size.width/2 - chevViewWidth/2, self.bounds.origin.y + self.bounds.size.height - chevViewHeight, chevViewWidth, chevViewWidth);
}

- (void)setScrollViewOffset:(CGFloat)scrollViewOffset
{
    _scrollViewOffset = scrollViewOffset;
    CGFloat fraction = fabs(scrollViewOffset) * 0.005;
    CGFloat darker  = CHEVRON_WHITE - fraction;
    CGFloat lighter = CHEVRON_WHITE + fraction;
    
    if (lighter > CHEVRON_WHITE_MAX)
        lighter = CHEVRON_WHITE_MAX;
    if (darker < CHEVRON_WHITE_MIN)
        darker = CHEVRON_WHITE_MIN;
    
    if (scrollViewOffset > 0) {
        self.bottomChevron.whiteColorLevel= lighter;
        self.topChevron.whiteColorLevel   =darker;
    }
    else if (scrollViewOffset < -1) {
        self.bottomChevron.whiteColorLevel= darker;
        self.topChevron.whiteColorLevel   = lighter;
    }
    else {
        self.bottomChevron.whiteColorLevel= CHEVRON_WHITE;
        self.topChevron.whiteColorLevel   = CHEVRON_WHITE;
    }
    [self setNeedsDisplay];
}


- (void)bounceChevron:(MYSDynamicAlertViewDirection)direction {
    CGFloat damping = 0.2;
    CGFloat dampingAfterAnimation = 0.5;
    CGFloat distance = 12;
    CGFloat duration = 1;
    CGFloat originalXtopChevron = self.topChevron.center.x;
    CGFloat originalYtopChevron =  self.topChevron.center.y;
    CGFloat originalXbottomChevron = self.bottomChevron.center.x;
    CGFloat originalYBottomChevron =  self.bottomChevron.center.y;

    if (direction == MYSDynamicAlertViewDirectionUp) {
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:0.6 options:0 animations:^{
            self.topChevron.center = CGPointMake(originalXtopChevron, originalYtopChevron + distance);
        } completion:^(BOOL finished){

        }];
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:dampingAfterAnimation initialSpringVelocity:0.6 options:0 animations:^{
            self.topChevron.center = CGPointMake(originalXtopChevron, originalYtopChevron);
        }completion:^(BOOL finished){
            
        }];
    }
    else if(direction == MYSDynamicAlertViewDirectionDown) {
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:0.6 options:0 animations:^{
            self.bottomChevron.center = CGPointMake(originalXbottomChevron, originalYBottomChevron - distance);
        } completion:^(BOOL finished){
            
        }];
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:dampingAfterAnimation initialSpringVelocity:0.6 options:0 animations:^{
            self.bottomChevron.center = CGPointMake(originalXbottomChevron, originalYBottomChevron);
        }completion:^(BOOL finished){
        }];
    }
}


#pragma mark - private

- (UIBezierPath *)chevron:(CGRect)frame direction:(MYSDynamicAlertViewDirection)direction
{
    UIBezierPath* bezierPath = [[UIBezierPath alloc]init];
    switch (direction) {
        case MYSDynamicAlertViewDirectionUp:
            [bezierPath setLineJoinStyle:kCGLineJoinRound];
            [bezierPath setLineCapStyle:kCGLineCapRound];
            [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
            [bezierPath addLineToPoint:CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y)];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
            break;
            
        case MYSDynamicAlertViewDirectionDown:
            [bezierPath setLineJoinStyle:kCGLineJoinRound];
            [bezierPath setLineCapStyle:kCGLineCapRound];
            [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
            [bezierPath addLineToPoint:CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height)];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
            break;
            
        default:
            [bezierPath setLineJoinStyle:kCGLineJoinRound];
            [bezierPath setLineCapStyle:kCGLineCapRound];
            [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
            break;
    }
    return bezierPath;
}

@end
