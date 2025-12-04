//
//  EstadisticasViewController.m
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import "EstadisticasViewController.h"
#import "AppDelegate.h"
#import "Habito+CoreDataClass.h"
#import "Accion+CoreDataClass.h"
#import "Categoria+CoreDataClass.h"
#import "BarChartView.h"

@interface EstadisticasViewController ()

@end

@implementation EstadisticasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cargarEstadisticas];
    // Do any additional setup after loading the view.
}

- (void)cargarEstadisticas {
    NSManagedObjectContext *context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;

    NSFetchRequest *fetch = [Habito fetchRequest];
    NSError *error = nil;
    NSArray *habitos = [context executeFetchRequest:fetch error:&error];
    if (error || habitos.count == 0) return;

    double impactoTotal = 0.0;
    NSMutableDictionary *porCategoria = [NSMutableDictionary dictionary];
    NSMutableDictionary *porDia = [NSMutableDictionary dictionary];
    NSMutableDictionary *porSemana = [NSMutableDictionary dictionary];
    NSMutableDictionary *porMes = [NSMutableDictionary dictionary];
    NSMutableDictionary *co2PorMes = [NSMutableDictionary dictionary];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];

    // Inicializar los 7 días de la semana
    NSArray *diasSemana = @[@"Lun", @"Mar", @"Mié", @"Jue", @"Vie", @"Sáb", @"Dom"];
    for (NSString *dia in diasSemana) {
        porSemana[dia] = @(0);
    }

    for (Habito *h in habitos) {
        Accion *a = h.accion;
        if (!a || !a.categoria) continue;

        impactoTotal += a.impacto;

        // Categoría
        NSString *cat = a.categoria.nombre ?: @"Sin categoría";
        porCategoria[cat] = @([porCategoria[cat] integerValue] + 1);

        // Día
        NSDateComponents *diaComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:h.fecha];
        NSString *claveDia = [NSString stringWithFormat:@"%04ld-%02ld-%02ld", diaComp.year, diaComp.month, diaComp.day];
        porDia[claveDia] = @([porDia[claveDia] integerValue] + 1);

        // Día de la semana (1 = domingo, 2 = lunes, ..., 7 = sábado)
        NSInteger index = diaComp.weekday == 1 ? 6 : diaComp.weekday - 2;
        NSString *nombreDia = diasSemana[index];
        porSemana[nombreDia] = @([porSemana[nombreDia] integerValue] + 1);

        // Mes (solo año actual)
        if (diaComp.year == currentYear) {
            NSString *claveMes = [NSString stringWithFormat:@"%02ld", diaComp.month];
            porMes[claveMes] = @([porMes[claveMes] integerValue] + 1);
            co2PorMes[claveMes] = @([co2PorMes[claveMes] doubleValue] + a.impacto);
        }
    }

    // Promedio diario
    double promedioDiario = porDia.count > 0 ? (double)habitos.count / porDia.count : 0.0;

    // Día más activo
    NSString *diaMasActivo = nil;
    NSInteger maxHabitos = 0;
    for (NSString *dia in porDia) {
        NSInteger cantidad = [porDia[dia] integerValue];
        if (cantidad > maxHabitos) {
            maxHabitos = cantidad;
            diaMasActivo = dia;
        }
    }

    // Categoría más frecuente
    NSString *categoriaFrecuente = nil;
    NSInteger maxCat = 0;
    for (NSString *cat in porCategoria) {
        NSInteger cantidad = [porCategoria[cat] integerValue];
        if (cantidad > maxCat) {
            maxCat = cantidad;
            categoriaFrecuente = cat;
        }
    }

    double impactoPromedio = habitos.count > 0 ? impactoTotal / habitos.count : 0.0;

    // Mostrar en etiquetas
    self.impactoTotalLabel.text = [NSString stringWithFormat:@"%.1f kg CO₂", impactoTotal];
    self.promedioHabitoDiarioLabel.text = [NSString stringWithFormat:@"%.1f hábitos por día", promedioDiario];
    self.impactoPromedioHabitoLabel.text = [NSString stringWithFormat:@"%.1f kg CO₂ por hábito", impactoPromedio];
    self.categoriaFrecuenteLabel.text = categoriaFrecuente ?: @"N/A";
    self.diaMasActivoLabel.text = diaMasActivo ?: @"N/A";

    // Ordenar meses cronológicamente
    NSArray *ordenMeses = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    NSMutableDictionary *porMesOrdenado = [NSMutableDictionary dictionary];
    NSMutableDictionary *co2MesOrdenado = [NSMutableDictionary dictionary];

    for (NSString *mes in ordenMeses) {
        if (porMes[mes]) porMesOrdenado[mes] = porMes[mes];
        if (co2PorMes[mes]) co2MesOrdenado[mes] = co2PorMes[mes];
    }

    // Dibujar gráficas
    [self dibujarGraficoEn:self.porCategoriaView conDatos:porCategoria limitarA:5];
    [self dibujarGraficoEn:self.porSemanaView conDatos:porSemana limitarA:0];
    [self dibujarGraficoEn:self.porMesView conDatos:porMesOrdenado limitarA:0];
    [self dibujarGraficoEn:self.coPorMesView conDatos:co2MesOrdenado limitarA:0];
}

- (void)dibujarGraficoEn:(UIView *)vista conDatos:(NSDictionary *)datos limitarA:(NSInteger)limite {
    for (UIView *sub in vista.subviews) {
        [sub removeFromSuperview];
    }

    NSArray *clavesOrdenadas = [datos keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj2 compare:obj1];
    }];

    NSMutableDictionary *filtrado = [NSMutableDictionary dictionary];
    NSInteger total = limite > 0 ? MIN(limite, clavesOrdenadas.count) : clavesOrdenadas.count;

    for (int i = 0; i < total; i++) {
        NSString *clave = clavesOrdenadas[i];
        filtrado[clave] = datos[clave];
    }

    // Si no hay límite, mantener orden original (porSemana y porMes ya vienen ordenados)
    if (limite == 0) {
        filtrado = [datos mutableCopy];
    }

    BarChartView *grafico = [[BarChartView alloc] initWithFrame:vista.bounds];
    grafico.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    grafico.datos = filtrado;
    grafico.titulo = nil;
    grafico.backgroundColor = UIColor.systemBackgroundColor;
    [vista addSubview:grafico];
}

@end
