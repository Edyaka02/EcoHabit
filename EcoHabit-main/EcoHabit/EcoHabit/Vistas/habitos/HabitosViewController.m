//
//  HabitosViewController.m
//  EcoHabit
//
//  Created by Victor Manuel Tijerina Garnica on 29/11/25.
//

#import "HabitosViewController.h"

@interface HabitosViewController ()

@end

@implementation HabitosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)mostrarCategorias:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Categoría"
                                                                   message:@"Selecciona una opción"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *all = [UIAlertAction actionWithTitle:@"Todos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.categoriaField.text = @"Todos";
    }];

    UIAlertAction *walk = [UIAlertAction actionWithTitle:@"Caminar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.categoriaField.text = @"Caminar";
    }];

    UIAlertAction *recycle = [UIAlertAction actionWithTitle:@"Reciclar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.categoriaField.text = @"Reciclar";
    }];

    UIAlertAction *electricity = [UIAlertAction actionWithTitle:@"Electricidad" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //[self.categoriaButton setTitle:@"Electricidad ▼" forState:UIControlStateNormal];
        self.categoriaField.text = @"Electricidad";
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:all];
    [alert addAction:walk];
    [alert addAction:recycle];
    [alert addAction:electricity];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}
@end
