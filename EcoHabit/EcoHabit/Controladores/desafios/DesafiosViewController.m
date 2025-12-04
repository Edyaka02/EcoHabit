//
//  DesafiosViewController.m
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import "DesafiosViewController.h"
#import "AppDelegate.h"
#import "Desafio+CoreDataClass.h"

@interface DesafiosViewController ()

@end

@implementation DesafiosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.desafiosTable.delegate = self;
    self.desafiosTable.dataSource = self;

    [self.segmentoControl addTarget:self action:@selector(segmentoCambiado:) forControlEvents:UIControlEventValueChanged];
    [self cargarDesafios];
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;

    NSFetchRequest *request = [Desafio fetchRequest];
    NSError *error = nil;
    NSArray *desafios = [context executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@" Error al obtener desafíos: %@", error.localizedDescription);
    } else {
        NSLog(@"Desafíos encontrados: %lu", (unsigned long)desafios.count);
        for (Desafio *d in desafios) {
            NSLog(@"Nombre: %@\n   Descripción: %@\n   Progreso: %.hd", d.nombre, d.descripcion, d.progreso);
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self cargarDesafios];
}

- (void)segmentoCambiado:(UISegmentedControl *)sender {
    [self.desafiosTable reloadData];
}

- (void)cargarDesafios {
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;

    NSFetchRequest *request = [Desafio fetchRequest];
    NSError *error = nil;
    NSArray *todos = [context executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"Error al obtener desafíos: %@", error.localizedDescription);
        return;
    }

    NSMutableArray *activos = [NSMutableArray array];
    NSMutableArray *completados = [NSMutableArray array];

    for (Desafio *d in todos) {
        if (d.progreso < 1.0) {
            [activos addObject:d];
        } else {
            [completados addObject:d];
        }
    }

    self.desafiosActivos = activos;
    self.desafiosCompletados = completados;
    [self.desafiosTable reloadData];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.segmentoControl.selectedSegmentIndex == 0 ? self.desafiosActivos.count : self.desafiosCompletados.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *celda = [tableView dequeueReusableCellWithIdentifier:@"DesafioCell" forIndexPath:indexPath];

    Desafio *d = self.segmentoControl.selectedSegmentIndex == 0 ? self.desafiosActivos[indexPath.row] : self.desafiosCompletados[indexPath.row];
    
    NSLog(@"Mostrar desafio: %@ (%hd)", d.nombre, d.progreso);

    UILabel *tituloLabel = [celda viewWithTag:1];
    UILabel *descripcionLabel = [celda viewWithTag:2];
    UIProgressView *barraProgreso = [celda viewWithTag:3];

    tituloLabel.text = d.nombre;
    descripcionLabel.text = d.descripcion;
    barraProgreso.progress = d.progreso;

    return celda;
}


@end
