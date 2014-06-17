//
//  MYSDynamicContentView.h
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import <UIKit/UIKit.h>
#import "MYSContentView.h"

@interface MYSDynamicScrollView : UIScrollView
@property (nonatomic, strong) MYSContentView *contentView;
@end
