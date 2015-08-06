//
//  FMLogger.h
//  
//  Created by Felix Mo on 11-08-21.
//
//  Copyright (c) 2011 Felix Mo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
// 
// 
//   Requirements
//  --------------
//     iOS 4.0+
//  
//
//   Log Levels
//  ------------
//
//  -> FMLoggerVerbose(fmt, ...)  - for detailed informational messages used for debugging
//  -> FMLoggerInfo(fmt, ...)     - for general informational messages that highlight the progress of the application
//  -> FMLoggerWarning(fmt, ...)  - for informational messages that highlight potential error events
//  -> FMLoggerError(fmt, ...)    - for informational messages pretaining to error events 


#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>


//  Identifer constants (unnecessary to change)
// ---------------------------------------------

#define FM_BACKGROUND_QUEUE_LABEL "com.felixmo.FMLogger.backgroundQueue"
#define FM_DATE_FORMATTER_KEY @"FMLoggerDateFormatter"


//  Settings
// ----------

#define FM_LOGS_MAX_AGE 60*60*24*7*1  
//
// Defines the maximum age of a log file before it is purged
//
// Default: 60*60*24*7*1
// Accepted values: time in seconds, as an integer; like NSTimeInterval (secs*mins*hrs*days*weeks)


#define FM_LOGS_DEFAULT_FOLDER_NAME @"Logs"     
//
// Name of the directory in which the log files will be stored in
// This directory will be created in "Documents" directory of the application
//
// Default: @"Logs"
// Accepted values: any string that is a legal directory name (i.e. does not contain any special characters (?, %, #, @, etc.)


#define FM_LOGS_FILENAME_FORMAT @"YYYY-MM-dd" 
//
// Date format string to be used to name the log files
//
// Default: @"YYYY-MM-dd"
// Accepted values: a date format string that is compliant with NSDateFormatter
// Note: See the 'Data Formatting Guide" in the iOS SDK documentation for a list of the conversion specifiers permitted in date format strings


#define FM_LOGS_INCLUDE_FUNC_AND_LINE 1
//
// States wether the function that called FMLogger and the number of which line it was called on should be logged (useful for debugging)
//
// Default: 1
// Accepted values: 0 (NO), 1 (YES)


//  Output formatting
// -------------------

#define FM_FORMAT_MSG_TIMESTAMP @"YYYY-MM-dd HH:mm:ss ZZZ"
//
// Date format string for the timestamp on log entries
//
// Default: @"YYYY-MM-dd HH:mm:ss ZZZ"
// Accepted values: a date format string that is compliant with NSDateFormatter
// Note: See the 'Data Formatting Guide" in the iOS SDK documentation for a list of the conversion specifiers permitted in date format strings


#define FM_FORMAT_MSG @"%@ | [%@] | %@"                                 
//
// Format string to be used as a template for messages that do NOT include the calling function and line number
//
// Example: 2011-12-28 18:11:43 -0500 | [INFO] | Entry named "Untitled" was created
//
// Default: @"%@ | [%@] | %@" 
// Accepted values: any format string that accepts 3 string arguments
// 
// Order of arguments:
// 1. Timestamp (string, %@)
// 2. Log level (string, %@)
// 3. Message   (string, %@)


#define FM_FORMAT_FUNC_LINE_MSG @"%@ | [%@] | %@ | %s @ (line %d)"      
//
// Format string to be used as a template for messages that include the calling function and line number
//
// Example: 2011-12-28 18:11:43 -0500 | [INFO] | Entry named "Untitled" was created | -[Model createEntryWithName:] @ (line 45)
//
// Default: @"%@ | [%@] | %@ | %s @ (line %d)" 
// Accepted values: any format string that accepts 5 arguments: 
//                  the first three are strings, 
//                  the next is a null-terminated array of 8-bit unsigned characters (the name of the function), 
//                  and the next an integer (the line number)
// 
// Order of arguments:
// 1. Timestamp (string, %@)
// 2. Log level (string, %@)
// 3. Message   (string, %@)
// 4. Function  (chars., %s)
// 5. Line #    (int,    %d)


//  Log level type
// ----------------

typedef enum {
    
    FMLoggerLevelVerbose,
    FMLoggerLevelInfo,
    FMLoggerLevelWarning,
    FMLoggerLevelError
    
} FMLoggerLevel;


//  FMLogger interface
// --------------------

@interface FMLogger : NSObject

+ (id)sharedLogger;
// Returns a reference to the shared instance of FMLogger; uses this instead of initalizing a new instance every time


- (void)logEventAtLevel:(FMLoggerLevel)level withMessage:(NSString *)fmt, ...NS_FORMAT_FUNCTION(2, 3); 
//
// Use this to log messages
//
// Ex. usage: [[FMLogger sharedLogger] logEventAtLevel:FMLoggerLevelInfo withMessage:@"HTTP request returned status code: %i", [response statusCode]];


- (void)logEventAtLevel:(FMLoggerLevel)level forFunction:(const char *)func atLine:(int)line withMessage:(NSString *)fmt, ...NS_FORMAT_FUNCTION(4, 5); 
//
// Mainly for use with the defined C macros
//
// Ex. usage: [[FMLogger sharedLogger] logEventAtLevel:FMLoggerLevelInfo 
//                                         forFunction:__PRETTY_FUNCTION__ 
//                                              atLine:__LINE__ 
//                                         withMessage:@"HTTP request returned status code: %i", [response statusCode]];

- (void)writeImageDoloadErrorInfoToLogFile:(NSString *)info;
- (void)deleteImageDoloadErrorInfoLogs;
- (NSString *)getImageDoloadErrorInfoLogs;

- (void)createDbErrorLogFile;
- (void)writeEErrorToLogFile:(NSString *)data;
   
@end // FMLogger


//  C macros
// ----------
//
// Use (with appropriate log levels) in place of NSLog
//
// Ex. usage: FMLoggerVerbose(@"Touch event detected at point (%1.0f, %1.0f), point.x, point.y);

// Verbose
#define FMLoggerVerbose(...) \
[[FMLogger sharedLogger] logEventAtLevel:FMLoggerLevelVerbose forFunction:__PRETTY_FUNCTION__ atLine:__LINE__ withMessage:__VA_ARGS__];
    
// Info
#define FMLoggerInfo(...) \
[[FMLogger sharedLogger] logEventAtLevel:FMLoggerLevelInfo forFunction:__PRETTY_FUNCTION__ atLine:__LINE__ withMessage:__VA_ARGS__];

// Warning
#define FMLoggerWarning(...) \
[[FMLogger sharedLogger] logEventAtLevel:FMLoggerLevelWarning forFunction:__PRETTY_FUNCTION__ atLine:__LINE__ withMessage:__VA_ARGS__];

// Error
#define FMLoggerError(...) \
[[FMLogger sharedLogger] logEventAtLevel:FMLoggerLevelError forFunction:__PRETTY_FUNCTION__ atLine:__LINE__ withMessage:__VA_ARGS__];


//  Preprocessor Directives (DO NOT MODIFY, for use during compile)
// -----------------------------------------------------------------

// Disable verbose logging outside of debug builds
#ifndef DEBUG
    #undef FMLoggerVerbose
    #define FMLoggerVerbose(...) do {} while (0)
#endif