//
//  MYSContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/17/14.
//
//

#import "MYSContentView.h"

@interface MYSContentView ()
@property (nonatomic, assign) BOOL isDragged;
@property (nonatomic, assign) BOOL isStartedTapped;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;

@end

@implementation MYSContentView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width,20)];
        label.text = @"^";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        // Down
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height - 20, self.bounds.size.width, 20)];
        label.text = @"v";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pointOfContact = [gestureRecognizer locationInView:self];
    
    // The view with a tag of 200 is my A view.
    NSLog(@"TAPPED");
    [self.delegate contentViewPressed:self];
    self.isDragged = YES;

    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"began");
    self.isDragged = NO;
    [self.delegate contentViewPressed:self];
    [self startTimer];
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"moved");
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isDragged) {
            // do some button debouncing
            [self stopTimer];
            double time = [self timeElapsedInSeconds];
            if (time > 0.8) {
                [self.delegate contentViewEndTap:self];
            }
            self.isStartedTapped = NO;
        }
    });
    NSLog(@"ended");
    
}

- (void) startTimer {
    self.start = [NSDate date];
}

- (void) stopTimer {
    self.end = [NSDate date];
}

- (double) timeElapsedInSeconds {
    return [self.end timeIntervalSinceDate:self.start];
}

@end
