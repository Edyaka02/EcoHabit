//
//  HistorialViewController.m
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import "AppDelegate.h"
#import "HistorialViewController.h"
#import "HistorialCell.h"
#import "Habito+CoreDataClass.h"
#import "Habito+CoreDataProperties.h"
#import "Accion+CoreDataClass.h"
#import "Accion+CoreDataProperties.h"
#import "Categoria+CoreDataClass.h"
#import "Categoria+CoreDataProperties.h"

@interface HistorialViewController ()

@end

@implementation HistorialViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSFetchRequest *request = [Habito fetchRequest];
    NSError *error = nil;
    self.habitos = [self.context executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"Error al obtener hábitos: %@", error.localizedDescription);
    } else {
        NSLog(@"Se cargaron %lu hábitos", (unsigned long)self.habitos.count);
        [self.historialTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        self.context = appDelegate.persistentContainer.viewContext;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.habitos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistorialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HabitoCell" forIndexPath:indexPath];

    Habito *habito = self.habitos[indexPath.row];
    cell.nombreLabel.text = habito.accion.nombre;
    cell.categoriaLabel.text = habito.accion.categoria.nombre;
    cell.horaLabel.text = [self formatearHora:habito.fecha];
    cell.impactoLabel.text = [NSString stringWithFormat:@"%.1f kg CO₂", habito.accion.impacto];
    
    NSLog(@"   Acción: %@", habito.accion.nombre);
        NSLog(@"   Categoría: %@", habito.accion.categoria.nombre);
        NSLog(@"   Fecha: %@", habito.fecha);
        NSLog(@"   Impacto: %.1f kg CO₂", habito.accion.impacto);

    return cell;
}

- (NSString *)formatearHora:(NSDate *)fecha {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"h:mm a";
    return [formatter stringFromDate:fecha];
}

@end
