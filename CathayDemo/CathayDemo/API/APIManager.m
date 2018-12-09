//
//  APIManager.m
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/5.
//  臺北市立動物園_植物資料RID f18de02f-b6c9-47c0-8cda-50efad621c14
//  臺北市立動物園_植物資料 https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14
//

#import "APIManager.h"

@implementation APIManager

+ (void)fetchDataTaipeiVegetationCount:(int)count
                            StartIndex:(int)index
                     completionHandler:(void (^)(NSData * _Nullable data,
                                                 NSURLResponse * _Nullable response,
                                                 NSError * _Nullable error))completionHandler{
    
    NSString *dataTaipeiAPIString = @"https://data.taipei/opendata/datalist/apiAccess";
    NSURLComponents *components = [NSURLComponents componentsWithString:dataTaipeiAPIString];
    
    NSURLQueryItem *scopeItem = [NSURLQueryItem queryItemWithName:@"scope" value:@"resourceAquire"];
    NSURLQueryItem *ridItem = [NSURLQueryItem queryItemWithName:@"rid" value:@"f18de02f-b6c9-47c0-8cda-50efad621c14"];
    NSURLQueryItem *limitItem = [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%d",count]];
    NSURLQueryItem *offsetItem = [NSURLQueryItem queryItemWithName:@"offset" value:[NSString stringWithFormat:@"%d",index]];
    
    components.queryItems = @[scopeItem,ridItem,limitItem,offsetItem];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:components.URL];
    
    [self fetchNetworkDataRequest:request handler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(data, response, error);
    }];
}


+ (void)fetchNetworkDataRequest:(NSURLRequest *)request handler:(void (^)(NSData * _Nullable data,
                                                                          NSURLResponse * _Nullable response,
                                                                          NSError * _Nullable error))handler {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                                          NSURLResponse * _Nullable response,
                                                                                          NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(data, response, error);
        });
    }];
    
    [task resume];
}


@end
