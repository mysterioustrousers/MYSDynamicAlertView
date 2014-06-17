//
//  MYSContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/17/14.
//
//

#import "MYSContentView.h"

@interface MYSContentView ()
@property (nonatomic, assign) BOOL isTapStarted;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;

@end

@implementation MYSContentView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        //self.backgroundColor = [UIColor blueColor];
        CGFloat height = self.bounds.size.height/1.8;
        CGFloat width = self.bounds.size.width;
        
        // Top
        self.upLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + height , width, height/4)];
        self.upLabel.text = @"Ok";
        self.upLabel.textAlignment = NSTextAlignmentCenter;
        //self.upLabel.hidden = YES;
        //self.upLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.upLabel];
        // Down
        self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height - height/4, width, height/4)];
        self.downLabel.text = @"Cancel";
        self.downLabel.textAlignment = NSTextAlignmentCenter;
        self.downLabel.hidden = YES;
        [self addSubview:self.downLabel];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y +  height/2.5, width, height)];
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //self.contentView.userInteractionEnabled = NO;
        [self addSubview:self.contentView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,20)];
        label.text = @"^";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        // Down
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + self.contentView.frame.size.height - 20, self.bounds.size.width, 20)];
        label.text = @"v";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

- (void)launch:(CGFloat)offset
{
    UIPushBehavior *pushBehavior    = [[UIPushBehavior alloc] initWithItems:@[self.upLabel] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection      = CGVectorMake(0, offset/10);
    [self.animator addBehavior:pushBehavior];
    [UIView animateWithDuration:0.4 animations:^{
    self.upLabel.center =CGPointMake(self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
        
    }];
    self.isTapStarted = NO;
}

- (void)snapOut
{
    if (self.isTapStarted) return;
    
    [self.animator removeAllBehaviors];
    self.upLabel.hidden = NO;
    //self.downLabel.hidden = NO;
    self.upLabel.center =CGPointMake(self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
    
    CGFloat subHeight = self.bounds.size.height/2;
    [UIView animateWithDuration:0.1 animations:^{
        self.upLabel.center =CGPointMake(self.bounds.size.width/2, self.bounds.origin.y + subHeight/4);
    }];
    self.isTapStarted = YES;
}

- (void)snapIn
{
    CGFloat subHeight = self.bounds.size.height/2;
    [UIView animateWithDuration:0.4 animations:^{
        self.upLabel.center =CGPointMake(self.bounds.size.width/2, self.bounds.origin.y + subHeight);
    }];
    self.isTapStarted = NO;
}

# pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"began");
    [self snapOut];
    [self startTimer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // do some button debouncing
            [self stopTimer];
            double time = [self timeElapsedInSeconds];
            if (time > 0.8) {
                [self snapIn];
            }
            self.isTapStarted = NO;
    });
    NSLog(@"ended");
}

# pragma mark - private


- (void) startTimer
{
    self.start = [NSDate date];
}

- (void) stopTimer
{
    self.end = [NSDate date];
}

- (double) timeElapsedInSeconds
{
    return [self.end timeIntervalSinceDate:self.start];
}

@end
