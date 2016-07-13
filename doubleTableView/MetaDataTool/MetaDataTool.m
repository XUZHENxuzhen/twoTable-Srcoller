//
//  MetaDataTool.m


#import "MetaDataTool.h"
#import "Stock.h"

@implementation MetaDataTool

+ (NSArray *)customStocks{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"customStocks.plist" ofType:nil]];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Stock *stock = [Stock new];
        [stock setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:stock];
    }
    return mutableArray;
}

@end
