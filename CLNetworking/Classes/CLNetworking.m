//
//  CLNetworking.m
//  CLNetworking
//
//  Created by Chris on 16/2/2.
//  Copyright © 2016年 chrislian. All rights reserved.
//

#import "CLNetworking.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger,CLHttpMethod){
    cl_GET = 0,
    cl_POST,
};

static BOOL g_isEnabelDebug  = false;
static BOOL g_autoEncode     = false;
static CLResponseType g_resonseType = kCLResponseTypeJSON;
static CLRequestType g_requestType  = kCLRequestTypeJSON;
static NSDictionary *g_httpHeader      = nil;
static NSTimeInterval g_requestTimeOut = 10;

@implementation CLNetworking
#pragma mark - setter & getter
/**
 *  当前是否在调试功能
 *
 *  @return true or false
 */
+ (BOOL)cl_debug{
    return g_isEnabelDebug;
}

/**
 *  是否启动调试,默认为false
 *
 *  @param isDebug true or false
 */
+ (void)cl_enableDebug:(BOOL)isDebug{
    if (g_isEnabelDebug != isDebug) {
        g_isEnabelDebug = isDebug;
    }
}

/**
 *  是否开启自动将URL使用UTF-8编码,处理链接中含有中文时无法完成请求,默认为false
 *
 *  @param autoEncode true or false;
 */
+ (void)cl_autoEncodeUrl:(BOOL)autoEncode{
    if (g_autoEncode != autoEncode) {
        g_autoEncode = autoEncode;
    }
}

/**
 *  配置返回格式,默认为JSON
 *
 *  @param responseType @see CLResponseType
 */
+ (void)cl_configResponseType:(CLResponseType)responseType{
    if (g_resonseType != responseType) {
        g_resonseType = responseType;
    }
}

/**
 *  配置请求格式,默认为JSON
 *
 *  @param requestType @see CLRequestType
 */
+ (void)cl_configRequestType:(CLRequestType)requestType{
    if (g_requestType != requestType) {
        g_requestType = g_requestType;
    }
}

/**
 *  配置http请求头
 *
 *  @param httpHeader NSDictionnary
 */
+ (void)cl_configHttpHeader:(NSDictionary *)httpHeader{
    g_httpHeader = httpHeader;
}
/**
 *  配置请求超时时间
 *
 *  @param interval 默认为10s
 */
+ (void)cl_configTimeOut:(NSTimeInterval)interval{
    if (g_requestTimeOut != interval) {
        g_requestTimeOut = interval;
    }
}

#pragma mark - get requeset
/**
 *  GET 请求 -- 不带参数
 *
 *  @param urlString 请求地址
 *  @param success   @see CLResponseSuccess
 *  @param failure   @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_getUrlString:(NSString *)urlString
                              success:(CLResponseSuccess)success
                              failure:(CLResponseFailure)failure{
    
    return [self cl_requestUrlString:urlString
                          httpMethod:cl_GET
                           parameter:nil
                            progress:nil
                             success:success
                             failure:failure];
}

/**
 *  GET 请求
 *
 *  @param urlString 请求地址
 *  @param parmaters 参数
 *  @param success   @see CLResponseSuccess
 *  @param failure   @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_getUrlString:(NSString *)urlString
                            parameter:(NSDictionary *)parmaters
                              success:(CLResponseSuccess)success
                              failure:(CLResponseFailure)failure{
    
    return [self cl_requestUrlString:urlString
                          httpMethod:cl_GET
                           parameter:parmaters
                            progress:nil
                             success:success
                             failure:failure];
}

/**
 *  GET 请求
 *
 *  @param urlString 请求地址
 *  @param parmaters 参数
 *  @param progress  @see CLDownLoadProgress
 *  @param success   @see CLResponseSuccess
 *  @param failure   @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_getUrlString:(NSString *)urlString
                            parameter:(NSDictionary *)parmaters
                             progress:(CLDownloadProgress)progress
                              success:(CLResponseSuccess)success
                              failure:(CLResponseFailure)failure{
    
    return [self cl_requestUrlString:urlString
                          httpMethod:cl_GET
                           parameter:parmaters
                            progress:progress
                             success:success
                             failure:failure];
}

#pragma mark -  post request
/**
 *  POST 请求
 *
 *  @param urlString 请求地址
 *  @param parmaters 请求参数
 *  @param success   @see CLResponseSuccess
 *  @param failure   @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_postUrlString:(NSString *)urlString
                             parameter:(NSDictionary *)parmaters
                               success:(CLResponseSuccess)success
                               failure:(CLResponseFailure)failure{
    
    return [self cl_requestUrlString:urlString
                          httpMethod:cl_POST
                           parameter:parmaters
                            progress:nil
                             success:success
                             failure:failure];
}

/**
 *  POST 请求
 *
 *  @param urlString 请求地址
 *  @param parmaters 请求参数
 *  @param progress  @see CLDwonLoadProgress
 *  @param success   @see CLResponseSuccess
 *  @param failure   @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_postUrlString:(NSString *)urlString
                             parameter:(NSDictionary *)parmaters
                              progress:(CLDownloadProgress)progress
                               success:(CLResponseSuccess)success
                               failure:(CLResponseFailure)failure{
    
    return [self cl_requestUrlString:urlString
                          httpMethod:cl_POST
                           parameter:parmaters
                            progress:progress
                             success:success
                             failure:failure];
}

#pragma mark - upload image

/**
 *  图片上传接口
 *
 *  @param image     图片对象
 *  @param urlString 上传地址
 *  @param filename  图片名字,默认为yyyyMMddHHmmss.jpg
 *  @param name      与制定图片相关联的名称,由后端制定,如imagefiles
 *  @param mimeType  默认为image/jpeg
 *  @param paramters 参数
 *  @param progress  @see CLUploadProgress
 *  @param success   @see CLResponseSuccess
 *  @param failure   @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_uploadImage:(UIImage *)image
                           urlString:(NSString *)urlString
                            filename:(NSString *)filename
                                name:(NSString *)name
                            mimeType:(NSString *)mimeType
                           parameter:(NSDictionary *)paramters
                            progress:(CLUploadProgress)progress
                             success:(CLResponseSuccess)success
                             failure:(CLResponseFailure)failure{
    
    if ([NSURL URLWithString:urlString] == nil) {
        NSLog(@"urlString invalid");
        return nil;
    }
    return [[self cl_manager] POST:urlString
                        parameters:paramters
         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
             
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task,
                id  _Nullable responseObject) {
        
        [self successResponse:responseObject callback:success];
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - upload file
/**
 *  上传文件
 *
 *  @param filepath  文件路径
 *  @param urlString 上传地址
 *  @param progress  @see CLUploadProgress
 *  @param success   @see CLResponseSuccess
 *  @param failure   @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_uploadFile:(NSString *)filePath
                          urlString:(NSString *)urlString
                           progress:(CLUploadProgress)progress
                            success:(CLResponseSuccess)success
                            failure:(CLResponseFailure)failure{
    
    NSURL *uploadURL = [NSURL URLWithString:urlString];
    if (uploadURL == nil) {
        NSLog(@"urlString invalid");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self cl_manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    
    return [manager uploadTaskWithRequest:request
                                 fromFile:[NSURL URLWithString:filePath]
                                 progress:^(NSProgress * _Nonnull uploadProgress) {
                                     
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
                                     
    } completionHandler:^(NSURLResponse * _Nonnull response,
                          id  _Nullable responseObject,
                          NSError * _Nullable error) {
        
        [self successResponse:responseObject callback:success];
        
        if (error && failure) {
            failure(error);
        }
    }];
}

#pragma mark - download file
/**
 *  下载文件
 *
 *  @param saveFilePath 文件保存路径
 *  @param urlString    下载地址
 *  @param progress     @see CLDownloadProgress
 *  @param success      @see CLResponseSuccess
 *  @param failure      @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_downloadFile:(NSString *)saveFilePath
                            urlString:(NSString *)urlString
                             progress:(CLDownloadProgress)progress
                              success:(CLResponseSuccess)success
                              failure:(CLResponseFailure)failure{
    
    NSURL *downloadURL = [NSURL URLWithString:urlString];
    if (downloadURL == nil) {
        NSLog(@"urlString invalid");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self cl_manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    return [manager downloadTaskWithRequest:request
                                   progress:^(NSProgress * _Nonnull downloadProgress) {
                                       
        if (progress) {
            progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath,
                                    NSURLResponse * _Nonnull response) {
        
        return [NSURL URLWithString:saveFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response,
                          NSURL * _Nullable filePath,
                          NSError * _Nullable error) {
        
        if (success) {
            success(filePath.absoluteString);
        }
        if (error && failure) {
            failure(error);
        }
    }];
}


#pragma mark - private method
/**
 *  配置 AFHttpSessionmanager
 *
 *  @return return AFHTTPSessionManager
 */
+ (AFHTTPSessionManager *)cl_manager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //request
    switch (g_requestType) {
        case kCLRequestTypeJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        }
        case kCLRequestTypePlianText: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
    }
    
    //response
    switch (g_resonseType) {
        case kCLResponseTypeJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case kCLResponseTypeXML: {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case kCLResponseTypeCustom: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
    }
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    //
    for (NSString *key in g_httpHeader.allKeys){
        if (g_httpHeader[key]) {
            [manager.requestSerializer setValue:g_httpHeader[key] forKey:key];
        }
    }
    NSArray *array = @[@"application/json",
                       @"text/html",
                       @"text/json",
                       @"text/plain",
                       @"text/javascript",
                       @"text/xml",
                       @"image/*"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:array];
    
    //请求超时时间
    manager.requestSerializer.timeoutInterval = g_requestTimeOut;
    
    //并发数
    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    return manager;
}

/**
 *  请求接口
 *
 *  @param urlString  请求地址
 *  @param httpMethod @see CLHttpMethod
 *  @param parameters 请求参数
 *  @param progress   @see CLDwonLoadProgress
 *  @param success    @see CLResponseSuccess
 *  @param failure    @see CLResponseFailure
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)cl_requestUrlString:(NSString *)urlString
                               httpMethod:(CLHttpMethod)httpMethod
                                parameter:(NSDictionary *)parameters
                                 progress:(CLDownloadProgress)progress
                                  success:(CLResponseSuccess)success
                                  failure:(CLResponseFailure)failure{
    
    
    if ([NSURL URLWithString:urlString] == nil) {
        NSLog(@"urlString invalid");
        return nil;
    }
    AFHTTPSessionManager *manager = [self cl_manager];
    switch (httpMethod) {
        case cl_GET: {
            return [manager GET:urlString
                     parameters:parameters
                       progress:^(NSProgress * _Nonnull downloadProgress) {
                           
                if (progress) {
                    progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
                }
                           
            } success:^(NSURLSessionDataTask * _Nonnull task,
                        id  _Nullable responseObject) {
                
                [self successResponse:responseObject callback:success];
                
            } failure:^(NSURLSessionDataTask * _Nullable task,
                        NSError * _Nonnull error) {
                
                if (failure) {
                    failure(error);
                }
            }];
            break;
        }
        case cl_POST: {
            return [manager POST:urlString
                      parameters:parameters
                        progress:^(NSProgress * _Nonnull uploadProgress) {
                            
                if (progress) {
                    progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task,
                        id  _Nullable responseObject) {
                
                [self successResponse:responseObject callback:success];
                
            } failure:^(NSURLSessionDataTask * _Nullable task,
                        NSError * _Nonnull error) {
                
                if (failure) {
                    failure(error);
                }
            }];
            break;
        }
    }
}


/**
 *  解析返回数据
 *
 *  @param responseObject 返回数据
 *
 *  @return 解析后的数据
 */
+ (id)cl_prarseResponseObject:(id)responseObject {
    if (!responseObject || ![responseObject isKindOfClass:[NSData class]]) {
        return responseObject;
    }
    
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return responseObject;
    }
    return response;
}

/**
 *  处理请求成功返回的数据
 *
 *  @param responseObject 返回数据
 *  @param success        @see CLResponseSuccess
 */
+ (void)successResponse:(id)responseObject callback:(CLResponseSuccess)success {
    if (success) {
        success([self cl_prarseResponseObject:responseObject]);
    }
}


@end
