//
//  AppDelegate.h
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (void)cargarDatosIniciales;

@end

