//
//  VegetationManager.h
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VegetationManager : NSObject
+ (void) fetchVegetationDataCount:(int)count StartIndex:(int)index completionHandler:(void (^)(NSArray * _Nullable resultArray, NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
