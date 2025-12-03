//
//  HabitosViewController.m
//  EcoHabit
//
//  Created by Victor Manuel Tijerina Garnica on 29/11/25.
//

#import "AppDelegate.h"
#import "HabitosViewController.h"
#import "Categoria+CoreDataClass.h"
#import "Accion+CoreDataClass.h"
#import "Habito+CoreDataClass.h"
#import "DatosIncialesManager.h"

@interface HabitosViewController ()

@end

@implementation HabitosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.context) {
            AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
            self.context = appDelegate.persistentContainer.viewContext;
        }
    
    [DatosIncialesManager cargarEnContexto:self.context];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

 
- (IBAction)guardarHabito:(id)sender {
    if (!self.accionSeleccionada || self.habitoField.text.length == 0) return;

    NSDate *fecha = self.fechaPicker.date;
    NSDate *hora = self.horaPicker.date;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *fechaComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:fecha];
    NSDateComponents *horaComp = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:hora];

    NSDateComponents *finalComp = [[NSDateComponents alloc] init];
    finalComp.year = fechaComp.year;
    finalComp.month = fechaComp.month;
    finalComp.day = fechaComp.day;
    finalComp.hour = horaComp.hour;
    finalComp.minute = horaComp.minute;

    NSDate *fechaFinal = [calendar dateFromComponents:finalComp];

    Habito *nuevoHabito = [NSEntityDescription insertNewObjectForEntityForName:@"Habito" inManagedObjectContext:self.context];
    nuevoHabito.nombre = self.habitoField.text;
    nuevoHabito.fecha = fechaFinal;
    nuevoHabito.impacto = self.accionSeleccionada.impacto;
    nuevoHabito.accion = self.accionSeleccionada;

    NSError *error = nil;
    if ([self.context save:&error]) {
        NSLog(@"Hábito guardado correctamente");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"Error al guardar hábito: %@", error.localizedDescription);
    }
    
    NSFetchRequest *fetchRequest = [Habito fetchRequest];
    NSError *fetchError = nil;
    NSArray *todosLosHabitos = [self.context executeFetchRequest:fetchRequest error:&fetchError];

    if (fetchError) {
        NSLog(@"❌ Error al obtener todos los hábitos: %@", fetchError.localizedDescription);
    } else {
        NSLog(@"📋 Lista de hábitos guardados (%lu):", (unsigned long)todosLosHabitos.count);
        for (Habito *habito in todosLosHabitos) {
            NSLog(@"- Acción: %@ | Categoría: %@ | Fecha: %@ | Impacto: %.1f kg CO₂",
                  habito.accion.nombre,
                  habito.accion.categoria.nombre,
                  habito.fecha,
                  habito.accion.impacto);
        }
    }
    
    
}

- (IBAction)seleccionarAccion:(id)sender {
    if (!self.categoriaSeleccionada) return;

    NSFetchRequest *request = [Accion fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoria == %@", self.categoriaSeleccionada];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *acciones = [self.context executeFetchRequest:request error:&error];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Selecciona acción" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (Accion *accion in acciones) {
        [alert addAction:[UIAlertAction actionWithTitle:accion.nombre style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.accionSeleccionada = accion;
            self.accionField.text = accion.nombre;
            self.impactoField.text = [NSString stringWithFormat:@"%.2f", accion.impacto];
            if (self.habitoField.text.length == 0) {
                self.habitoField.text = accion.nombre;
            }
        }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)seleccionarCategoria:(id)sender {
    
    if (!self.context) {
        NSLog(@"El contexto es nil. No se puede cargar datos.");
        return;
    }
    
    NSLog(@"Categorías presionadas");
    
    NSFetchRequest *request = [Categoria fetchRequest];
    NSError *error = nil;
    NSArray *categorias = [self.context executeFetchRequest:request error:&error];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Selecciona categoría" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (Categoria *cat in categorias) {
        [alert addAction:[UIAlertAction actionWithTitle:cat.nombre style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.categoriaSeleccionada = cat;
            self.categoriaField.text = cat.nombre;
            self.accionSeleccionada = nil;
            self.accionField.text = @"";
            self.impactoField.text = @"";
        }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
