//
//  ViewController.m
//  doubleTableView

//

#import "ViewController.h"
#import "UIView+customView.h"
#import "MetaDataTool.h"
#import "Stock.h"
#import "RightTableViewCell.h"
#import "Masonry.h"
#define LeftTableViewWidth 100
#define RightLabelWidth 80
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView  *rightTableView;

@property (nonatomic,strong) NSArray *rightTitles;
@property (nonatomic,strong) NSArray *customStocks;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *buttomScrollView;

@end


@implementation ViewController

#pragma mark - 懒加载属性
- (NSArray *)customStocks{
    if (!_customStocks) {
        _customStocks = [MetaDataTool customStocks];
    }
    return _customStocks;
}

-(NSArray *)rightTitles{
    if (!_rightTitles) {
        _rightTitles = @[@"最新", @"涨幅%", @"涨跌", @"昨收", @"成交量", @"成交额", @"最高", @"最低"];
    }
    return _rightTitles;
}


#pragma mark - 设置主页面
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自选股票";
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
//        self.rightTableView.contentInset = UIEdgeInsetsMake(88, 0, 88, 0);
//    }
    [self loadLeftTableView];
    [self loadRightTableView];
    
}
//设置分割线顶格
//在ios7中，UITableViewCell左侧会有默认15像素的空白。这时候，设置setSeparatorInset:UIEdgeInsetsZero 能将空白去掉
- (void)viewDidLayoutSubviews{
    [self.leftTableView setLayoutMargins:UIEdgeInsetsZero];
    //contentInset的API文档的解释是"内容视图嵌入到封闭的滚动视图的距离"
    self.rightTableView.contentInset = UIEdgeInsetsZero;
    [self.rightTableView setLayoutMargins:UIEdgeInsetsZero];
    self.rightTableView.frame = CGRectMake(0, 0, self.rightTitles.count * RightLabelWidth + 20, CGRectGetHeight(self.buttomScrollView.frame));
    self.buttomScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.rightTableView.frame), 0);
}

- (void)loadLeftTableView{
    self.leftTableView.tableFooterView = [UIView new];
      NSLog(@"leftTableView%@",NSStringFromCGRect(self.leftTableView.frame));
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
  
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [self.buttomScrollView addSubview:self.rightTableView];
    }
    return _rightTableView;
}
- (void)loadRightTableView{
//    CGFloat height = CGRectGetHeight(self.buttomScrollView.frame);
//    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.rightTitles.count * RightLabelWidth + 20, height) style:UITableViewStylePlain];
//    self.rightTableView.delegate = self;
//    self.rightTableView.dataSource = self;
//
//    self.rightTableView.showsVerticalScrollIndicator = NO;
//    self.buttomScrollView.contentSize = CGSizeMake(self.rightTableView.frame.size.width, 0);
//        [self.buttomScrollView addSubview:self.rightTableView];
//       NSLog(@"rightTableView %@",NSStringFromCGRect(self.rightTableView.frame));
//    NSLog(@"contentSize %@",NSStringFromCGSize(self.buttomScrollView.contentSize));
//    NSLog(@"bottomScrollView %@",NSStringFromCGRect(self.buttomScrollView.frame));
   }

#pragma mark - table view dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        static NSString *reuseIdentifer = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifer];
            [self resetSeparatorInsetForCell:cell];
        }
        Stock *stock = self.customStocks[indexPath.row % 7];
        cell.detailTextLabel.text = stock.number;
        cell.textLabel.text = stock.title;
      
        return cell;
    }else{
        RightTableViewCell *cell = [RightTableViewCell cellWithTableView:tableView WithNumberOfLabels:self.rightTitles.count];
        //这里先使用假数据
        UIView *view = [cell.contentView viewWithTag:100];
        for (UILabel *label in view.subviews) {
            label.text = nil;
            label.text = [NSString stringWithFormat:@"%ld", indexPath.row];
        }
        return cell;
    }
}
//设置cell分割线顶格
- (void)resetSeparatorInsetForCell:(UITableViewCell *)cell {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.customStocks.count *20
    ;
}
#pragma mark -- 设置左右两个table View的自定义头部View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.rightTableView) {
        UIView *rightHeaderView = [UIView viewWithLabelNumber:self.rightTitles.count];
        int i = 0;
        for (UILabel *label in rightHeaderView.subviews) {
            label.text = self.rightTitles[i++];
        }
        rightHeaderView.backgroundColor = [UIColor lightGrayColor];
        return rightHeaderView;
    }else{
        
        UIView *leftHeaderView = [UIView viewWithLabelNumber:1];
        [leftHeaderView.subviews.lastObject setText:@"自选股票"];
        leftHeaderView.backgroundColor = [UIColor lightGrayColor];
        return leftHeaderView;
    }
}
//必须实现以下方法才可以使用自定义头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
        [self.rightTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - 两个tableView联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.leftTableView) {
        [self tableView:self.rightTableView scrollFollowTheOther:self.leftTableView];
    }else{
        [self tableView:self.leftTableView scrollFollowTheOther:self.rightTableView];
    }
}

- (void)tableView:(UITableView *)tableView scrollFollowTheOther:(UITableView *)other{
    CGFloat offsetY= other.contentOffset.y;
    CGPoint offset=tableView.contentOffset;
    offset.y=offsetY;
    tableView.contentOffset=offset;
}

@end
