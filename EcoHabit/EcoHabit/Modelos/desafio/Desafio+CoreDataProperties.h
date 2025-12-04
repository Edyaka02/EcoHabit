//
//  Desafio+CoreDataProperties.h
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//
//

#import "Desafio+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Desafio (CoreDataProperties)

+ (NSFetchRequest<Desafio *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSDate *fechaFin;
@property (nullable, nonatomic, copy) NSDate *fechaInicio;
@property (nonatomic) int16_t meta;
@property (nonatomic) int16_t progreso;
@property (nullable, nonatomic, copy) NSString *nombre;
@property (nullable, nonatomic, copy) NSString *descripcion;
@property (nonatomic) BOOL completado;
@property (nullable, nonatomic, retain) Categoria *categoria;

@end

NS_ASSUME_NONNULL_END
