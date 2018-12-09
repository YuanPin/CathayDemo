//
//  VegetationManager.m
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/6.
//

#import "VegetationManager.h"
#import "APIManager.h"
#import "TaipeiZooVegetationModel.h"
@implementation VegetationManager

+ (void) fetchVegetationDataCount:(int)count
                       StartIndex:(int)index
                completionHandler:(void (^)(NSArray * _Nullable resultArray,
                                            NSError * _Nullable error))completionHandler{
    [APIManager fetchDataTaipeiVegetationCount:count StartIndex:index completionHandler:^(
                                                                                          NSData * _Nullable data,
                                                                                          NSURLResponse * _Nullable response,
                                                                                          NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200){
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"APIData:%@",responseDictionary);

            if (parseError != nil){
                completionHandler(nil, parseError);
            } else {
                NSDictionary *resutlDict = responseDictionary[@"result"];
                if (resutlDict[@"results"]){
                    NSArray *resutlArray = resutlDict[@"results"];
                    NSMutableArray *modelArray = [NSMutableArray new];
                    for (NSDictionary *dataDict in resutlArray) {
                        TaipeiZooVegetationModel *model = [[TaipeiZooVegetationModel alloc]initWithDict:dataDict];
                        [modelArray addObject:model];
                    }
                    completionHandler(modelArray, nil);
                } else {
                    completionHandler(nil, nil);
                }
            }
        } else {
            completionHandler(nil, error);
        }
    }];
    
}

@end
