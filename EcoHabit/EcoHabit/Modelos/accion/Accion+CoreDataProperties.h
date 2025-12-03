//
//  Accion+CoreDataProperties.h
//  EcoHabit
//
//  Created by Victor Manuel Tijerina Garnica on 03/12/25.
//
//

#import "Accion+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Accion (CoreDataProperties)

+ (NSFetchRequest<Accion *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *nombre;
@property (nonatomic) double impacto;
@property (nullable, nonatomic, copy) NSString *unidad;
@property (nullable, nonatomic, retain) NSSet<Habito *> *habitos;
@property (nullable, nonatomic, retain) Categoria *categoria;

@end

@interface Accion (CoreDataGeneratedAccessors)

- (void)addHabitosObject:(Habito *)value;
- (void)removeHabitosObject:(Habito *)value;
- (void)addHabitos:(NSSet<Habito *> *)values;
- (void)removeHabitos:(NSSet<Habito *> *)values;

@end

NS_ASSUME_NONNULL_END
