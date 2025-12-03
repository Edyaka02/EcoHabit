//
//  DatosIncialesManager.h
//  EcoHabit
//
//  Created by Victor Manuel Tijerina Garnica on 03/12/25.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatosIncialesManager : NSObject

+ (void)cargarEnContexto:(NSManagedObjectContext *)context;

+ (void)borrarTodoEnEntidad:(NSString *)nombreEntidad contexto:(NSManagedObjectContext *)context;


@end

NS_ASSUME_NONNULL_END
