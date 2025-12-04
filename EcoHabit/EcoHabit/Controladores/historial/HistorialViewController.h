//
//  HistorialViewController.h
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistorialViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *habitos;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITableView *historialTableView;

@end

NS_ASSUME_NONNULL_END
