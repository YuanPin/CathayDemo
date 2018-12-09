//
//  TaipeiZooVegetationModel.h
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaipeiZooVegetationModel : NSObject

@property (nonatomic, nullable, strong) NSString *fNameCh;
@property (nonatomic, nullable, strong) NSString *fLocation;
@property (nonatomic, nullable, strong) NSString *fFeature;
@property (nonatomic, nullable, strong) NSString *fPic01URL;
@property (nonatomic, nullable, strong) NSURL * picURL;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
