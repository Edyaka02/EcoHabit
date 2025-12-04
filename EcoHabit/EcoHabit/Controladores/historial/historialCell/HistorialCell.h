//
//  HistorialCell.h
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistorialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nombreLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriaLabel;
@property (weak, nonatomic) IBOutlet UILabel *horaLabel;
@property (weak, nonatomic) IBOutlet UILabel *impactoLabel;
@property (weak, nonatomic) IBOutlet UIView *tarjetaView;

@end

NS_ASSUME_NONNULL_END
