//
//  VegetationTableViewCell.m
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/6.
//

#import "VegetationTableViewCell.h"
#import "APIManager.h"

@implementation VegetationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 設定Cell顯示資料
- (void)setVegetationDataModel:(TaipeiZooVegetationModel *)vegetationDataModel {
    self.nameLabel.text = vegetationDataModel.fNameCh;
    self.locationLabel.text = vegetationDataModel.fLocation;
    self.featureLabel.text = vegetationDataModel.fFeature;

    if (vegetationDataModel.fPic01URL != nil) {
        [self downloadImageData:vegetationDataModel.fPic01URL];
    }
}

#pragma mark - 下載Image
-(void)downloadImageData:(NSString *)imageURLString {
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [APIManager fetchNetworkDataRequest:request handler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            UIImage* vegetationImage = [UIImage imageWithData:data];
            CGFloat imageRatio = vegetationImage.size.width/ vegetationImage.size.height;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageAspectRatioConstraint.constant = imageRatio;
                self.PicImageView.image = vegetationImage;
            });
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
