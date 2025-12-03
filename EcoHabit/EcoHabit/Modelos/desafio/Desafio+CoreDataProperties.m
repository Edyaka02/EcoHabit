//
//  Desafio+CoreDataProperties.m
//  EcoHabit
//
//  Created by Victor Manuel Tijerina Garnica on 03/12/25.
//
//

#import "Desafio+CoreDataProperties.h"

@implementation Desafio (CoreDataProperties)

+ (NSFetchRequest<Desafio *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Desafio"];
}

@dynamic fechaFin;
@dynamic fechaInicio;
@dynamic meta;
@dynamic progreso;
@dynamic nombre;
@dynamic descripcion;
@dynamic completado;
@dynamic categoria;

@end
