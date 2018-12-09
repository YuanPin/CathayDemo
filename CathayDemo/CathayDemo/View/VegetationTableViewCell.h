//
//  VegetationTableViewCell.h
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/6.
//

#import <UIKit/UIKit.h>
#import "TaipeiZooVegetationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VegetationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *featureLabel;

@property (strong, nonatomic) IBOutlet UIImageView *PicImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageAspectRatioConstraint;

@property (strong, nonatomic, nonnull) TaipeiZooVegetationModel *vegetationDataModel;

@end

NS_ASSUME_NONNULL_END
