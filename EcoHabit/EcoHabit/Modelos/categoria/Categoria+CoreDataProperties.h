//
//  Categoria+CoreDataProperties.h
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//
//

#import "Categoria+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Categoria (CoreDataProperties)

+ (NSFetchRequest<Categoria *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *nombre;
@property (nullable, nonatomic, retain) NSSet<Accion *> *acciones;
@property (nullable, nonatomic, retain) NSSet<Desafio *> *desafios;

@end

@interface Categoria (CoreDataGeneratedAccessors)

- (void)addAccionesObject:(Accion *)value;
- (void)removeAccionesObject:(Accion *)value;
- (void)addAcciones:(NSSet<Accion *> *)values;
- (void)removeAcciones:(NSSet<Accion *> *)values;

- (void)addDesafiosObject:(Desafio *)value;
- (void)removeDesafiosObject:(Desafio *)value;
- (void)addDesafios:(NSSet<Desafio *> *)values;
- (void)removeDesafios:(NSSet<Desafio *> *)values;

@end

NS_ASSUME_NONNULL_END
