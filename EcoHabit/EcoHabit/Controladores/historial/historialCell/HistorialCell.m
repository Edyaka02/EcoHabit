//
//  HistorialCell.m
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//

#import "HistorialCell.h"

@implementation HistorialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tarjetaView.layer.cornerRadius = 10;
    self.tarjetaView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tarjetaView.layer.shadowOpacity = 0.1;
    self.tarjetaView.layer.shadowOffset = CGSizeMake(0, 2);
    self.tarjetaView.layer.shadowRadius = 4;
    self.tarjetaView.layer.masksToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
