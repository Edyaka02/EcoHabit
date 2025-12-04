//
//  DatosIncialesManager.m
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//

#import "DatosIncialesManager.h"
#import "Categoria+CoreDataClass.h"
#import "Accion+CoreDataClass.h"
#import "Desafio+CoreDataClass.h"
#import "Habito+CoreDataClass.h"

@implementation DatosIncialesManager

+ (void)borrarTodoEnEntidad:(NSString *)nombreEntidad contexto:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:nombreEntidad];
    fetchRequest.includesPropertyValues = NO; // Más eficiente
    
    NSError *error = nil;
    NSArray *objetos = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error al obtener objetos de %@: %@", nombreEntidad, error.localizedDescription);
        return;
    }
    
    for (NSManagedObject *objeto in objetos) {
        [context deleteObject:objeto];
    }
    
    if ([context hasChanges]) {
        [context save:&error];
        if (error) {
            NSLog(@"Error al guardar cambios al borrar %@: %@", nombreEntidad, error.localizedDescription);
        } else {
            NSLog(@"Todos los objetos de %@ fueron eliminados", nombreEntidad);
        }
    }
}

+ (void)poblarDatosAleatoriosEnContexto:(NSManagedObjectContext *)context {
    NSError *error = nil;

    // Borrar todo
    [self borrarTodoEnEntidad:@"Accion" contexto:context];
    [self borrarTodoEnEntidad:@"Categoria" contexto:context];
    [self borrarTodoEnEntidad:@"Desafio" contexto:context];
    [self borrarTodoEnEntidad:@"Habito" contexto:context];

    // Crear categorías
    NSArray *nombresCategorias = @[@"Transporte", @"Energía", @"Alimentación", @"Residuos", @"Agua", @"Consumo responsable"];
    NSMutableArray *categorias = [NSMutableArray array];

    for (NSString *nombre in nombresCategorias) {
        Categoria *c = [NSEntityDescription insertNewObjectForEntityForName:@"Categoria" inManagedObjectContext:context];
        c.nombre = nombre;
        [categorias addObject:c];
    }

    // Crear acciones aleatorias
    NSArray *nombresAcciones = @[
        @"Usar bicicleta", @"Apagar luces", @"Comer vegetariano", @"Reciclar papel", @"Ducha corta",
        @"Comprar ropa usada", @"Evitar carne roja", @"Reutilizar bolsas", @"Teletrabajar", @"Lavar con agua fría",
        @"Reparar fugas", @"Comprar a granel", @"Evitar fast fashion", @"Compartir auto", @"Desconectar aparatos"
    ];

    NSArray *unidades = @[@"por día", @"por uso", @"por semana", @"por acción", @"por kg", @"por ducha"];

    for (int i = 0; i < 40; i++) {
        Accion *a = [NSEntityDescription insertNewObjectForEntityForName:@"Accion" inManagedObjectContext:context];
        a.nombre = nombresAcciones[arc4random_uniform((uint32_t)nombresAcciones.count)];
        a.impacto = ((double)arc4random_uniform(300) + 50) / 100.0;
        a.unidad = unidades[arc4random_uniform((uint32_t)unidades.count)];
        a.categoria = categorias[arc4random_uniform((uint32_t)categorias.count)];
    }

    // Crear desafíos aleatorios
    NSArray *nombresDesafios = @[
        @"Sin plástico por 7 días", @"Transporte verde", @"Ahorro de energía",
        @"Semana sin carne", @"Reciclaje diario", @"Ducha de 5 minutos",
        @"Sin compras innecesarias", @"Apagar dispositivos", @"Cero residuos por 3 días",
        @"Hidratación consciente", @"Desconexión digital", @"Cocina sin desperdicio"
    ];

    NSArray *descripcionesDesafios = @[
        @"Evita usar productos de plástico de un solo uso.",
        @"Usa medios de transporte sostenibles toda la semana.",
        @"Reduce tu consumo eléctrico diario.",
        @"No consumas carne durante una semana.",
        @"Recicla todos los días por una semana.",
        @"Limita tus duchas a 5 minutos.",
        @"No compres nada innecesario por 7 días.",
        @"Desconecta aparatos que no uses.",
        @"No generes basura durante 3 días.",
        @"Reduce el consumo de agua en casa.",
        @"Evita pantallas por 2 horas al día.",
        @"Cocina solo lo necesario para evitar desperdicios."
    ];

    for (int i = 0; i < 15; i++) {
        Desafio *d = [NSEntityDescription insertNewObjectForEntityForName:@"Desafio" inManagedObjectContext:context];
        NSUInteger idx = arc4random_uniform((uint32_t)nombresDesafios.count);
        d.nombre = nombresDesafios[idx];
        d.descripcion = descripcionesDesafios[idx];
        d.progreso = ((double)(arc4random_uniform(11))) / 10.0; // 0.0 a 1.0
    }
    
    // Obtener acciones existentes para asignarlas a hábitos
    NSFetchRequest *fetchAcciones = [Accion fetchRequest];
    NSArray *acciones = [context executeFetchRequest:fetchAcciones error:&error];

    if (acciones.count > 0) {
        for (int i = 0; i < 365; i++) {
            Habito *h = [NSEntityDescription insertNewObjectForEntityForName:@"Habito" inManagedObjectContext:context];

            // Fecha aleatoria en el último año
            NSTimeInterval segundosEnUnDia = 60 * 60 * 24;
            NSTimeInterval diasAleatorios = arc4random_uniform(365) * segundosEnUnDia;
            h.fecha = [NSDate dateWithTimeIntervalSinceNow:-diasAleatorios];

            // Acción aleatoria
            Accion *accionAleatoria = acciones[arc4random_uniform((uint32_t)acciones.count)];
            h.accion = accionAleatoria;
        }
    } else {
        NSLog(@"No se generaron hábitos porque no hay acciones disponibles");
    }

    [context save:&error];
    if (error) {
        NSLog(@"Error al guardar datos aleatorios: %@", error.localizedDescription);
    } else {
        NSLog(@"Datos aleatorios cargados correctamente");
    }
}


@end
