//
//  CLNetworking.h
//  CLNetworking
//
//  Created by Chris on 16/2/2.
//  Copyright © 2016年 chrislian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  下载进度
 *
 *  @param currentBytes 当前已下载进度
 *  @param totalBytes   总的大小
 */
typedef void (^CLDownloadProgress)(int64_t currentBytes,int64_t totalBytes);
typedef CLDownloadProgress CLGetProgress;
typedef CLDownloadProgress CLPostProgress;

/**
 *  上传进度
 *
 *  @param currentBytes 当前已上传进度
 *  @param totalBytes   总的大小
 */
typedef void (^CLUploadProgress)(int64_t currentBytes,int64_t totalBytes);

typedef NS_ENUM(NSUInteger,CLResponseType){
    kCLResponseTypeJSON = 0,//default type
    kCLResponseTypeXML,
    kCLResponseTypeCustom,
};

typedef NS_ENUM(NSUInteger,CLRequestType){
    kCLRequestTypeJSON = 0,//default
    kCLRequestTypePlianText,
};


/**
 *  request success block
 *
 *  @param response
 */
typedef void (^CLResponseSuccess)(id response);

/**
 *  request failure block
 *
 *  @param error NSError
 */
typedef void (^CLResponseFailure)(NSError *error);

@interface CLNetworking : NSObject
/**
 *  当前是否在调试功能
 *
 *  @return true or false
 */
+ (BOOL)cl_debug;
/**
 *  是否启动调试,默认为false
 *
 *  @param isDebug true or false
 */
+ (void)cl_enableDebug:(BOOL)isDebug;

/**
 *  是否开启自动将URL使用UTF-8编码,处理链接中含有中文时无法完成请求,默认为false
 *
 *  @param autoEncode true or false;
 */
+ (void)cl_autoEncodeUrl:(BOOL)autoEncode;
/**
 *  配置返回格式,默认为JSON
 *
 *  @param responseType @see CLResponseType
 */
+ (void)cl_configResponseType:(CLResponseType)responseType;

/**
 *  配置请求格式,默认为JSON
 *
 *  @param requestType @see CLRequestType
 */
+ (void)cl_configRequestType:(CLRequestType)requestType;

/**
 *  配置http请求头
 *
 *  @param httpHeader NSDictionnary
 */
+ (void)cl_configHttpHeader:(NSDictionary *)httpHeader;

/**
 *  配置请求超时时间
 *
 *  @param interval 默认为10s
 */
+ (void)cl_configTimeOut:(NSTimeInterval)interval;

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
                              failure:(CLResponseFailure)failure;

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
                              failure:(CLResponseFailure)failure;

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
                              failure:(CLResponseFailure)failure;

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
                               failure:(CLResponseFailure)failure;


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
                               failure:(CLResponseFailure)failure;



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
                             failure:(CLResponseFailure)failure;

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
                            failure:(CLResponseFailure)failure;

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
                              failure:(CLResponseFailure)failure;
@end
