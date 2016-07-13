//
//  RightTableViewCell.m
//  doubleTableView

#import "RightTableViewCell.h"
#import "UIView+customView.h"

@implementation RightTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView WithNumberOfLabels:(NSInteger)number
{
    static NSString *identifier = @"cell";
    // 1.缓存中取
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
         cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        UIView *view = [UIView viewWithLabelNumber:number];
        view.tag = 100;
        [cell.contentView addSubview:view];

    }
    return cell;
}


@end
