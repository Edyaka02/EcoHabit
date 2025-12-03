//
//  HabitosViewController.h
//  EcoHabit
//
//  Created by Victor Manuel Tijerina Garnica on 29/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HabitosViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *categoriaButton;
@property (weak, nonatomic) IBOutlet UITextField *categoriaField;


- (IBAction)mostrarCategorias:(id)sender;

@end

NS_ASSUME_NONNULL_END
