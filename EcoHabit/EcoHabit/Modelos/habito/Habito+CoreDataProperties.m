//
//  Habito+CoreDataProperties.m
//  EcoHabit
//
//  Created by Victor Manuel Tijerina Garnica on 03/12/25.
//
//

#import "Habito+CoreDataProperties.h"

@implementation Habito (CoreDataProperties)

+ (NSFetchRequest<Habito *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Habito"];
}

@dynamic categoria;
@dynamic fecha;
@dynamic impacto;
@dynamic nombre;
@dynamic accion;

@end
