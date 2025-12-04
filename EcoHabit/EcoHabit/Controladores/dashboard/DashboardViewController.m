//
//  DashboardViewController.m
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "Habito+CoreDataClass.h"
#import "Accion+CoreDataClass.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self actualizarDashboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Dashboard";
    self.desafiosCollectionView.delegate = self;
    self.desafiosCollectionView.dataSource = self;
    
}

- (void)actualizarDashboard {
    // Limpiar gráfica anterior
    [self.graficaSemanalView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    NSFetchRequest *request = [Habito fetchRequest];
    NSError *error = nil;
    NSArray *habitos = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error al obtener hábitos: %@", error.localizedDescription);
        return;
    }
    
    // Progreso diario
    NSInteger completadosHoy = [self contarHabitosDeHoy:habitos];
    NSInteger metaDiaria = 5;
    self.progresoLabel.text = [NSString stringWithFormat:@"%ld/%ld hábitos", (long)completadosHoy, (long)metaDiaria];
    self.progresoView.progress = (float)completadosHoy / (float)metaDiaria;
    
    // Racha
    NSInteger racha = [self calcularRacha:habitos];
    self.rachaLabel.text = [NSString stringWithFormat:@"%ld días de racha", (long)racha];
    
    // Impacto de hoy
    double impactoHoy = [self calcularImpactoDeHoy:habitos];
    self.impactoLabel.text = [NSString stringWithFormat:@"%.1f kg CO₂", impactoHoy];
    
    // Desafíos activos
    self.desafios = @[@"Sin plástico", @"Transporte verde", @"Ahorro de energía"];
    [self.desafiosCollectionView reloadData];
    
    // Gráfica semanal
    [self dibujarGraficaSemanalConHabitos:habitos];
}

#pragma mark - Cálculos

- (NSInteger)contarHabitosDeHoy:(NSArray *)habitos {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *inicioHoy = [calendar startOfDayForDate:[NSDate date]];
    NSDate *finHoy = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:inicioHoy options:0];
    NSInteger count = 0;
    
    for (Habito *h in habitos) {
        if ([h.fecha compare:inicioHoy] != NSOrderedAscending &&
            [h.fecha compare:finHoy] == NSOrderedAscending) {
            count++;
        }
    }
    return count;
}

- (double)calcularImpactoDeHoy:(NSArray *)habitos {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *inicioHoy = [calendar startOfDayForDate:[NSDate date]];
    NSDate *finHoy = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:inicioHoy options:0];
    double total = 0;
    
    for (Habito *h in habitos) {
        if ([h.fecha compare:inicioHoy] != NSOrderedAscending &&
            [h.fecha compare:finHoy] == NSOrderedAscending) {
            total += h.accion.impacto;
        }
    }
    return total;
}

- (NSInteger)calcularRacha:(NSArray *)habitos {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSMutableSet *diasConHabito = [NSMutableSet set];
    
    for (Habito *h in habitos) {
        NSDate *soloFecha = [calendar startOfDayForDate:h.fecha];
        [diasConHabito addObject:soloFecha];
    }
    
    NSInteger racha = 0;
    NSDate *dia = [calendar startOfDayForDate:[NSDate date]];
    
    while ([diasConHabito containsObject:dia]) {
        racha++;
        dia = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:dia options:0];
    }
    
    return racha;
}

#pragma mark - Gráfica semanal

- (void)dibujarGraficaSemanalConHabitos:(NSArray *)habitos {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSMutableArray *valores = [NSMutableArray arrayWithCapacity:7];
    NSMutableArray *diasSemana = [NSMutableArray arrayWithCapacity:7];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"es_MX"];
    formatter.dateFormat = @"e"; // 1 = domingo, 2 = lunes, ..., 7 = sábado

    NSArray *diasCortos = @[@"D", @"L", @"M", @"M", @"J", @"V", @"S"];

    // Obtener los últimos 7 días (de hace 6 días hasta hoy)
    for (int i = 6; i >= 0; i--) {
        NSDate *dia = [calendar dateByAddingUnit:NSCalendarUnitDay value:-i toDate:[NSDate date] options:0];
        NSDate *inicio = [calendar startOfDayForDate:dia];
        NSDate *fin = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:inicio options:0];

        double total = 0;
        for (Habito *h in habitos) {
            NSDate *fechaHabito = [calendar startOfDayForDate:h.fecha];
            if ([fechaHabito compare:inicio] != NSOrderedAscending &&
                [fechaHabito compare:fin] == NSOrderedAscending) {
                total += h.accion.impacto;
            }
        }
        [valores addObject:@(total)];

        NSInteger index = [[formatter stringFromDate:dia] integerValue] - 1;
        [diasSemana addObject:diasCortos[index]];
    }

    // Limpiar vista anterior
    [self.graficaSemanalView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // Configuración visual
    CGFloat anchoBarra = 20;
    CGFloat espacio = 15;
    CGFloat alturaMax = self.graficaSemanalView.frame.size.height;
    CGFloat totalAncho = valores.count * anchoBarra + (valores.count - 1) * espacio;
    CGFloat inicioX = (self.graficaSemanalView.frame.size.width - totalAncho) / 2.0;

    for (int i = 0; i < valores.count; i++) {
        CGFloat valor = [valores[i] floatValue];
        CGFloat altura = (valor / 10.0) * alturaMax;

        CGFloat x = inicioX + i * (anchoBarra + espacio);
        CGFloat y = alturaMax - altura;

        // Barra
        UIView *barra = [[UIView alloc] initWithFrame:CGRectMake(x, y, anchoBarra, altura)];
        barra.backgroundColor = [UIColor systemGreenColor];
        barra.layer.cornerRadius = 4;
        [self.graficaSemanalView addSubview:barra];

        // Valor (kg CO₂)
        UILabel *valorLabel = [[UILabel alloc] initWithFrame:CGRectMake(x - 10, y - 20, 40, 16)];
        valorLabel.text = [NSString stringWithFormat:@"%.1f", valor];
        valorLabel.font = [UIFont systemFontOfSize:10];
        valorLabel.textAlignment = NSTextAlignmentCenter;
        valorLabel.textColor = [UIColor darkGrayColor];
        [self.graficaSemanalView addSubview:valorLabel];

        // Día
        UILabel *diaLabel = [[UILabel alloc] initWithFrame:CGRectMake(x - 5, alturaMax + 2, 30, 16)];
        diaLabel.text = diasSemana[i];
        diaLabel.font = [UIFont boldSystemFontOfSize:12];
        diaLabel.textAlignment = NSTextAlignmentCenter;
        diaLabel.textColor = [UIColor labelColor];
        [self.graficaSemanalView addSubview:diaLabel];
    }
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.desafios.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DesafioCell" forIndexPath:indexPath];
    
    UILabel *label = [cell viewWithTag:1];
    label.text = self.desafios[indexPath.item];
    
    return cell;
}

@end
