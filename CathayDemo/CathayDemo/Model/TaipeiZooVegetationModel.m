//
//  TaipeiZooVegetationModel.m
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/5.
//

#import "TaipeiZooVegetationModel.h"

@implementation TaipeiZooVegetationModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict[@"F_Name_Ch"]) {
            self.fNameCh = dict[@"F_Name_Ch"];
        }
        if (dict[@"F_Location"]) {
            self.fLocation = dict[@"F_Location"];
        }
        if (dict[@"F_Feature"]) {
            self.fFeature = dict[@"F_Feature"];
        }
        if (dict[@"F_Pic01_URL"]) {
            self.fPic01URL = dict[@"F_Pic01_URL"];
            self.picURL = [NSURL URLWithString:self.fPic01URL];
        }
    }
    return self;
}
@end
