//
//  DashboardViewController.h
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashboardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIProgressView *progresoView;
@property (weak, nonatomic) IBOutlet UILabel *progresoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rachaLabel;
@property (weak, nonatomic) IBOutlet UILabel *impactoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *desafiosCollectionView;
@property (weak, nonatomic) IBOutlet UIView *graficaSemanalView;

@property (strong, nonatomic) NSArray *desafios;

@end

NS_ASSUME_NONNULL_END
