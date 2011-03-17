//
//  AZ115URL.m
//  115SpeedUp
//
//  Created by Aladdin on 3/7/11.
//  Copyright 2011 innovation-works. All rights reserved.
//
//  Modified by sycx.

#import "AZ115URL.h"
#import "JSON.h"

@implementation AZ115URL

@synthesize fileNameString;
@synthesize a115URLString;
@synthesize chinaUnicomString;
@synthesize chinaTelecomString;
@synthesize backupString;
@synthesize isFounded;

- (void)dealloc
{
	[a115URLString release];
	[chinaUnicomString release];
	[chinaTelecomString release];
	[backupString release];
	[fileNameString release];
	[super dealloc];
}

- (void)getURLsFrom115ApiWithURL:(NSString*)aurl{
#define UeggVersion 1169
    isFounded = NO;
	self.a115URLString = aurl;
	NSString * pickcode = [a115URLString lastPathComponent];
	NSString * apiURL = [NSString stringWithFormat:@"http://u.115.com/?ct=upload_api&ac=get_pick_code_info&pickcode=%@&version=%d",pickcode,UeggVersion];
	NSString * retStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiURL] encoding:NSUTF8StringEncoding error:nil];
	NSDictionary * retDict = [retStr JSONValue];
    
    isFounded = [[retDict objectForKey:@"State"] boolValue];
	self.fileNameString = [retDict objectForKey:@"FileName"];
    
    NSArray *downloadUrls = [retDict objectForKey:@"DownloadUrl"];
    for (id obj in downloadUrls) {
        NSString *urlString = [obj objectForKey:@"Url"];
        if ([urlString doesContain:@"tel.115.cdn"])
            self.chinaTelecomString = urlString;
        else if ([urlString doesContain:@"cnc.115.cdn"])
            self.chinaTelecomString = urlString;
        else {
            self.backupString = urlString;
        }
    }
    
    if (!isFounded) {
        NSLog(@"->Warning:%@\t%@",pickcode,[retDict objectForKey:@"Message"]);
    }
    //	NSLog(@"%@",retDict);
}

-(NSURL *)URLWithSite:(siteIndex) site
{
    if (!isFounded) {
        return nil;
    }
    NSString *str = nil;
    switch (site) {
        case kChinaUnicomIndex:
            str = self.chinaUnicomString;
            break;
        case kChinaTelecomIndex:
            str = self.chinaTelecomString;
            break;
        case kBackupIndex:
            str = self.backupString;
            break;
        default:
            break;
    }
    if (!str) {
        if (self.backupString) str = self.backupString;
        else if (self.chinaTelecomString) str = self.chinaTelecomString;
        else if (self.chinaUnicomString) str = self.chinaUnicomString;
    }
    if (!str) {
        return nil;
    }
    NSURL *output = [NSURL URLWithString:str];
    return output;
}


@end
