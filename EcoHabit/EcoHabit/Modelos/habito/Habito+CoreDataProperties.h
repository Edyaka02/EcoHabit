//
//  Habito+CoreDataProperties.h
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//
//

#import "Habito+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Habito (CoreDataProperties)

+ (NSFetchRequest<Habito *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *categoria;
@property (nullable, nonatomic, copy) NSDate *fecha;
@property (nonatomic) double impacto;
@property (nullable, nonatomic, copy) NSString *nombre;
@property (nullable, nonatomic, retain) Accion *accion;

@end

NS_ASSUME_NONNULL_END
