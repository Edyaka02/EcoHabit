//
//  HabitosViewController.h
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class Accion;
@class Categoria;

@interface HabitosViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Accion *accionSeleccionada;
@property (strong, nonatomic) Categoria *categoriaSeleccionada;


@property (weak, nonatomic) IBOutlet UITextField *habitoField;
@property (weak, nonatomic) IBOutlet UIButton *categoriaButton;
@property (weak, nonatomic) IBOutlet UITextField *categoriaField;
@property (weak, nonatomic) IBOutlet UIButton *accionButton;
@property (weak, nonatomic) IBOutlet UITextField *accionField;
@property (weak, nonatomic) IBOutlet UIDatePicker *fechaPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *horaPicker;
@property (weak, nonatomic) IBOutlet UITextField *impactoField;

- (IBAction)seleccionarCategoria:(id)sender;
- (IBAction)seleccionarAccion:(id)sender;
- (IBAction)guardarHabito:(id)sender;


@end

NS_ASSUME_NONNULL_END
