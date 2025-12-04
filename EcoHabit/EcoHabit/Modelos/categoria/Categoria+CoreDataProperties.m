//
//  Categoria+CoreDataProperties.m
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//
//

#import "Categoria+CoreDataProperties.h"

@implementation Categoria (CoreDataProperties)

+ (NSFetchRequest<Categoria *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Categoria"];
}

@dynamic nombre;
@dynamic acciones;
@dynamic desafios;

@end
