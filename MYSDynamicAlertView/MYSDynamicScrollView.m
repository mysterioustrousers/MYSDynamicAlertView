//
//  MYSDynamicContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import "MYSDynamicScrollView.h"

@implementation MYSDynamicScrollView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat width   = self.bounds.size.width - self.bounds.size.width * 0.15;
        CGFloat height  = self.bounds.size.height / 2.5;
        self.contentView = [[MYSContentView alloc] initWithFrame:CGRectMake(self.center.x - width/2, self.center.y - height/2, width, height + 1)];
        self.contentView.center = self.center;
        self.contentView.contentView.tag = 200;
        
        [self addSubview:self.contentView];
        
        
        // Top
        self.scrollEnabled = YES;
        self.self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height + 1);
    }
    return self;
}

- (void)contentViewWasTapped:(id)sender
{
    NSLog(@"tapped");
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pointOfContact = [gestureRecognizer locationInView:self];
    
    // The view with a tag of 200 is content view
    if(![[self hitTest:pointOfContact withEvent:nil] isEqual:[self viewWithTag:200]])
    {
        return NO;
    }
    
    return YES;
}

@end
