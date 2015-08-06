//
//  FileUtil.h
//
//  Created by wangyong on 13/1/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

+ (BOOL)isExist:(NSString *)file;
+ (NSString *)getAudioPath;
+ (NSString *)getApiCachePath;

+ (NSString *)getFileName:(NSString *)path;
+ (NSString *)getFilePart:(NSString *)name idx:(NSInteger)idx;
+ (NSString *)getFileName:(NSString *)path suffix:(NSString *)suffix;
+ (NSString *)getBasePath;
+ (BOOL)isLocalFile:(NSString *)path;
+ (BOOL)clearDir:(NSString *)path;
+ (BOOL)clearFile:(NSString *)path;
+ (void)createDir:(NSString *)dirPath;
+ (NSString *)getSendDataPath;
+ (void)clearCache;
+ (void)moveItemToDir:(NSString*)file_path dir:(NSString*)dir;
@end
