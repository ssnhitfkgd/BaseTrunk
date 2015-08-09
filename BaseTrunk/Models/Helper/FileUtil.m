//
//  FileUtil.m
//
//  Created by wangyong on 13/1/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

+ (BOOL)isExist:(NSString *)file
{
    BOOL tf = YES;
    NSFileManager *nfm = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL isExist = [nfm fileExistsAtPath:file isDirectory:&isDir];
    if (isExist == NO || isDir == YES) {
        tf = NO;
        return tf;
    }
    tf = [nfm fileExistsAtPath:file];
    return tf;
}

+ (NSString *)getAudioPath
{
    return [[FileUtil getBasePath] stringByAppendingPathComponent:@"AudioCache"];
}

+ (NSString *)getApiCachePath
{
    return [[FileUtil getBasePath] stringByAppendingPathComponent:@"APICache"];
}

+ (NSString *)getSendDataPath
{
    return [[FileUtil getBasePath] stringByAppendingPathComponent:@"SendData"];
}



+ (NSString *)getFileName:(NSString *)path
{
    NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *name = nil;
    if (range.location == NSNotFound) {
        name = path;
    } else {
        // audio
        name = [path substringFromIndex:range.location+1];
    }
    return name;
}

+ (NSString *)getFilePart:(NSString *)name idx:(NSInteger)idx
{
    NSString *part = nil;
    NSRange range = [name rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        if (idx == 0) {
            part = [name substringToIndex:range.location];
        } else {
            part = [name substringFromIndex:range.location+1];
        }
    } else {
        if (idx == 0) {
            part = name;
        } else {
            part = @"";
        }
    }
    return part;

}

+ (NSString *)getFileName:(NSString *)path suffix:(NSString *)suffix
{
    NSString *name = nil;
    NSString *name2 = [FileUtil getFileName:path];
    NSRange range = [name2 rangeOfString:suffix options:NSBackwardsSearch];
    if (range.location != NSNotFound && range.location+range.length == name2.length-1) {
        name = [name2 substringToIndex:range.location];
    } else {
        name = name2;
    }
    return name;
}

+ (NSString *)getBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (BOOL)isLocalFile:(NSString *)path
{
    BOOL tf = YES;
    NSRange range = [path rangeOfString:[FileUtil getBasePath]];
    if (range.location == 0 && range.length > 0) {
        tf = YES;
    } else {
        tf = NO;
    }
    return tf;
}

+ (BOOL)clearDir:(NSString *)path
{
    BOOL tf = YES;
    NSFileManager *nfm = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL isExist = [nfm fileExistsAtPath:path isDirectory:&isDir];
    if (isExist == YES && isDir == YES) {
        NSArray *array = [nfm contentsOfDirectoryAtPath:path error:nil];
        for (int i=0; i<array.count; i++) {
            tf = [nfm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", path, [array objectAtIndex:i]] error:nil];
        }
    }
    return tf;
}

+ (BOOL)clearFile:(NSString *)path
{
    BOOL tf = YES;
    NSFileManager *nfm = [NSFileManager defaultManager];
    BOOL isExist = [nfm fileExistsAtPath: path];

    if (isExist == YES) {
        tf = [nfm removeItemAtPath: path error: nil];
    }

    return tf;
}

+ (void)createDir:(NSString *)dirPath
{
	NSFileManager *fileManage = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL isExist = [fileManage fileExistsAtPath:dirPath isDirectory:&isDir];
	if (isExist == NO || isDir == NO) {
		NSError *error;
		isDir = [fileManage createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
		NSLog(@"Create dir %@ %@", dirPath, isDir == YES ? @"OK":@"Fail");
	}
}

+ (void)load
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:[self getAudioPath]])
    {
        [manager createDirectoryAtPath:[self getAudioPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if(![manager fileExistsAtPath:[self getApiCachePath]])
    {
        [manager createDirectoryAtPath:[self getApiCachePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if(![manager fileExistsAtPath:[self getSendDataPath]])
    {
        [manager createDirectoryAtPath:[self getSendDataPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

+ (void)moveItemToDir:(NSString*)file_path dir:(NSString*)dirPath
{
    if([FileUtil isExist:file_path]){
        NSFileManager * manager = [NSFileManager defaultManager];
        
            [manager moveItemAtPath:file_path toPath:dirPath error:nil];
        
    }

}


+ (void)clearCache
{

}
@end
