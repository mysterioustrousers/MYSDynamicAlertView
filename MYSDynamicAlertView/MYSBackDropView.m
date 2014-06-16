//
//  MYSBackDropView.m
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import "MYSBackDropView.h"

@implementation MYSBackDropView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        // Top
        self.upLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, self.bounds.origin.y, 30, 20)];
        self.upLabel.text = @"Ok";
        [self addSubview:self.upLabel];
        // Left
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height/2 - 10,60, 20)];
        self.leftLabel.text = @"Cancel";
        [self addSubview:self.leftLabel];
        // Right
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 40, self.bounds.size.height/2 -10,40, 20)];
        self.rightLabel.text = @"Yo";
        [self addSubview:self.rightLabel];
        // Down
        self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height - 20,60, 20)];
        self.downLabel.text = @"Peep";
        [self addSubview:self.downLabel];
    }
    return self;
}

@end
