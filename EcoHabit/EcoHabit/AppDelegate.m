//
//  AppDelegate.m
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Modelos/accion/Accion+CoreDataClass.h"
#import "Modelos/categoria/Categoria+CoreDataClass.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self cargarDatosIniciales];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    if (_persistentContainer == nil) {
        _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"EcoHabit"];
        [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
            if (error != nil) {
                NSLog(@"Error al cargar persistent store: %@", error.localizedDescription);
                abort();
            }
        }];
    }
    return _persistentContainer;
}

- (void)cargarDatosIniciales {
    NSFetchRequest *request = [Accion fetchRequest];
    NSError *error = nil;
    NSUInteger count = [self.persistentContainer.viewContext countForFetchRequest:request error:&error];

    if (count > 0) return; // Ya existen acciones, no cargar de nuevo

    NSManagedObjectContext *context = self.persistentContainer.viewContext;

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

    // Guardar
    [context save:&error];
    if (error) {
        NSLog(@"Error al guardar datos iniciales: %@", error.localizedDescription);
    } else {
        NSLog(@"Categorías y acciones iniciales cargadas");
    }
}

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Error al guardar contexto: %@", error.localizedDescription);
        abort();
    }
}


@end
