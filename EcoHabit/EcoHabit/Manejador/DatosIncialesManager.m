//
//  DatosIncialesManager.m
//  EcoHabit
//
//  Created by Victor Manuel Tijerina Garnica on 03/12/25.
//

#import "DatosIncialesManager.h"
#import "Categoria+CoreDataClass.h"
#import "Accion+CoreDataClass.h"

@implementation DatosIncialesManager

+ (void)cargarEnContexto:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [Accion fetchRequest];
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    if (count > 0) return;

    // Crear categorías
    Categoria *transporte = [NSEntityDescription insertNewObjectForEntityForName:@"Categoria" inManagedObjectContext:context];
    transporte.nombre = @"Transporte";

    Categoria *energia = [NSEntityDescription insertNewObjectForEntityForName:@"Categoria" inManagedObjectContext:context];
    energia.nombre = @"Energía";

    Categoria *alimentacion = [NSEntityDescription insertNewObjectForEntityForName:@"Categoria" inManagedObjectContext:context];
    alimentacion.nombre = @"Alimentación";

    Categoria *residuos = [NSEntityDescription insertNewObjectForEntityForName:@"Categoria" inManagedObjectContext:context];
    residuos.nombre = @"Residuos";

    Categoria *agua = [NSEntityDescription insertNewObjectForEntityForName:@"Categoria" inManagedObjectContext:context];
    agua.nombre = @"Agua";

    Categoria *consumo = [NSEntityDescription insertNewObjectForEntityForName:@"Categoria" inManagedObjectContext:context];
    consumo.nombre = @"Consumo responsable";

    // Función auxiliar para crear acciones
    void (^crearAccion)(NSString *, double, NSString *, NSString *, Categoria *) = ^(NSString *nombre, double impacto, NSString *unidad, NSString *descripcion, Categoria *categoria) {
        Accion *accion = [NSEntityDescription insertNewObjectForEntityForName:@"Accion" inManagedObjectContext:context];
        accion.nombre = nombre;
        accion.impacto = impacto;
        accion.unidad = unidad;
        accion.categoria = categoria;
    };

    // Transporte
    crearAccion(@"Usar bicicleta", 1.2, @"por día", @"Evita emisiones al no usar auto", transporte);
    crearAccion(@"Caminar", 1.0, @"por día", @"Alternativa sin emisiones", transporte);
    crearAccion(@"Transporte público", 1.5, @"por día", @"Reduce emisiones por persona", transporte);
    crearAccion(@"Compartir auto", 1.8, @"por día", @"Menos autos, menos emisiones", transporte);
    crearAccion(@"Teletrabajar", 2.0, @"por día", @"Evita desplazamientos innecesarios", transporte);

    // Energía
    crearAccion(@"Apagar luces innecesarias", 0.2, @"por hora", @"Ahorro de energía", energia);
    crearAccion(@"Desconectar aparatos", 0.3, @"por día", @"Evita consumo fantasma", energia);
    crearAccion(@"Usar focos LED", 0.5, @"por foco", @"Menor consumo eléctrico", energia);
    crearAccion(@"Bajar el aire acondicionado", 1.0, @"por grado", @"Reduce consumo energético", energia);
    crearAccion(@"Lavar con agua fría", 0.8, @"por carga", @"Menor uso de energía", energia);

    // Alimentación
    crearAccion(@"Comer vegetariano", 2.0, @"por comida", @"Reduce huella de carbono", alimentacion);
    crearAccion(@"Evitar carne roja", 2.5, @"por comida", @"Alta reducción de emisiones", alimentacion);
    crearAccion(@"Comprar local", 1.5, @"por compra", @"Menos transporte, menos emisiones", alimentacion);
    crearAccion(@"Evitar comida procesada", 1.0, @"por comida", @"Menor impacto ambiental", alimentacion);
    crearAccion(@"Reducir desperdicio", 1.2, @"por día", @"Menos residuos y emisiones", alimentacion);

    // Residuos
    crearAccion(@"Reciclar papel", 0.5, @"por kg", @"Ahorra recursos y energía", residuos);
    crearAccion(@"Reciclar plástico", 0.8, @"por kg", @"Reduce contaminación y emisiones", residuos);
    crearAccion(@"Reutilizar bolsas", 0.3, @"por uso", @"Disminuye consumo de plástico", residuos);
    crearAccion(@"Compostar residuos", 1.0, @"por día", @"Evita emisiones de metano", residuos);
    crearAccion(@"Evitar productos desechables", 0.6, @"por uso", @"Reduce residuos y emisiones", residuos);

    // Agua
    crearAccion(@"Cerrar la llave al cepillarse", 0.2, @"por uso", @"Ahorra agua y energía", agua);
    crearAccion(@"Ducha corta", 0.5, @"por ducha", @"Menor consumo de agua caliente", agua);
    crearAccion(@"Reutilizar agua", 0.4, @"por uso", @"Ahorro en riego o limpieza", agua);
    crearAccion(@"Reparar fugas", 1.0, @"por reparación", @"Evita desperdicio constante", agua);

    // Consumo responsable
    crearAccion(@"Comprar ropa usada", 3.0, @"por prenda", @"Evita producción nueva", consumo);
    crearAccion(@"Evitar fast fashion", 2.5, @"por prenda", @"Reduce consumo intensivo", consumo);
    crearAccion(@"Reparar en lugar de reemplazar", 1.5, @"por objeto", @"Prolonga vida útil", consumo);
    crearAccion(@"Comprar a granel", 1.0, @"por compra", @"Menos empaques, menos emisiones", consumo);

    [context save:&error];
    if (error) {
        NSLog(@"Error al guardar datos iniciales: %@", error.localizedDescription);
    } else {
        NSLog(@"Datos iniciales cargados correctamente");
    }
}

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

@end
