//
//  DesafiosViewController.h
//  EcoHabit
//
//  Created by Guest User on 29/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesafiosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentoControl;
@property (weak, nonatomic) IBOutlet UITableView *desafiosTable;

@property (strong, nonatomic) NSArray *desafiosActivos;
@property (strong, nonatomic) NSArray *desafiosCompletados;

@end

NS_ASSUME_NONNULL_END
