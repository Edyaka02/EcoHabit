//
//  BarChartView.h
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BarChartView : UIView

@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *datos;
@property (nonatomic, strong) NSString *titulo;

@end

NS_ASSUME_NONNULL_END
