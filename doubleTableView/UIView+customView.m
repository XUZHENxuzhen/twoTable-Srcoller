//
//  UIView+customView.m
//  doubleTableView
//


#import "UIView+customView.h"
#define LabelWidth 80
#define LabelHeight 40

@implementation UIView (customView)

+ (UIView *)viewWithLabelNumber:(NSInteger)num{
    UIView *view = [[self alloc] initWithFrame:CGRectMake(0, 0, LabelWidth * num, LabelHeight)];
    for (int i = 0; i < num; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LabelWidth * i, 0, LabelWidth, LabelHeight)];
        label.tag = i;
        
        label.textAlignment = NSTextAlignmentRight;
        [view addSubview:label];
    }
    return view;
}

@end
