//
//  EstadisticasViewController.h
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EstadisticasViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *impactoTotalLabel;
@property (weak, nonatomic) IBOutlet UIView *porCategoriaView;
@property (weak, nonatomic) IBOutlet UIView *porSemanaView;
@property (weak, nonatomic) IBOutlet UIView *porMesView;
@property (weak, nonatomic) IBOutlet UIView *coPorMesView;
@property (weak, nonatomic) IBOutlet UILabel *promedioHabitoDiarioLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriaFrecuenteLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaMasActivoLabel;
@property (weak, nonatomic) IBOutlet UILabel *impactoPromedioHabitoLabel;

@end

NS_ASSUME_NONNULL_END
