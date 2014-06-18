//
//  MYSContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/17/14.
//
//

#import "MYSContentView.h"

@implementation MYSContentView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        self.userInteractionEnabled = NO;                                           // scrollView deals with touches
        self.backgroundColor        = [UIColor groupTableViewBackgroundColor];
        
        UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,20)];
        label.text          = @"^";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        // Down
        UILabel *down       = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height - 20, self.bounds.size.width, 20)];
        down.text           = @"v";
        down.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:down];
    }
    return self;
}


@end
