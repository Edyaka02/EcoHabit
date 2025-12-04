//
//  Accion+CoreDataProperties.m
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//
//

#import "Accion+CoreDataProperties.h"

@implementation Accion (CoreDataProperties)

+ (NSFetchRequest<Accion *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Accion"];
}

@dynamic nombre;
@dynamic impacto;
@dynamic unidad;
@dynamic habitos;
@dynamic categoria;

@end
