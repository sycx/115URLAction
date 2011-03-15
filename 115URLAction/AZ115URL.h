//
//  AZ115URL.h
//  115SpeedUp
//
//  Created by Aladdin on 3/7/11.
//  Copyright 2011 innovation-works. All rights reserved.
//
//  Modified by sycx.

#import <Cocoa/Cocoa.h>


@interface AZ115URL : NSObject {
	NSString * a115URLString;
    BOOL isFounded;
	
	NSString * chinaUnicomString;
	NSString * chinaTelecomString;
	NSString * backupString;
	
	NSString * fileNameString;
}

@property (nonatomic, copy) NSString *fileNameString;
@property (nonatomic, copy) NSString *a115URLString;
@property (nonatomic, copy) NSString *chinaUnicomString;
@property (nonatomic, copy) NSString *chinaTelecomString;
@property (nonatomic, copy) NSString *backupString;
@property (readonly) BOOL isFounded;

#pragma mark methods
- (void)getURLsFrom115ApiWithURL:(NSString*)aurl;
@end
