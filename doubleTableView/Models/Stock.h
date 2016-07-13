//
//  stock.h
//  doubleTableView
//


#import <Foundation/Foundation.h>

@interface Stock : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *number;
@property (nonatomic,strong) NSArray *data;

@end
