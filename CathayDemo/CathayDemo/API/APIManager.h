//
//  APIManager.h
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject
+ (void)fetchDataTaipeiVegetationCount:(int)count StartIndex:(int)index completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+ (void)fetchNetworkDataRequest:(NSURLRequest *)request handler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))handler;
@end

NS_ASSUME_NONNULL_END
