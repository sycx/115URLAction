//
//  _15URLAction.m
//  115URLAction
//
//  Created by sycx on 11-3-15.
//  Copyright 2011年 sycx. All rights reserved.
//

#import "_15URLAction.h"
#import "AZ115URL.h"
typedef enum { kNoneDownloadTool, kiGetter } DownloadTool;
@implementation _15URLAction

-(void)calliGetter
{
    NSMutableString *listString = [[NSMutableString alloc] init];
    
    NSArray *keys = [linkDict allKeys];
    for (NSString *key in keys) {
        NSString *linkString = [[linkDict objectForKey:key] absoluteString];
        NSString *record = [NSString stringWithFormat:@"{url:\"%@\",referrer:\"%@\"},",linkString,key];
        [listString appendString:record];
    }
    
    NSUInteger len = [listString length];
    NSString *downloadList = nil;
    if (len > 0) {
        downloadList = [listString substringToIndex:len -1];
    }
    [listString release];
    
    NSString *scriptSource = [NSString stringWithFormat:@"\
                              tell application \"iGetter\"\n\
                              set downloadList to { %@ }\n\
                              downloadURL downloadList\n\
                              end tell",downloadList];
    
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSource];
    NSDictionary *errDict = nil;
    [script executeAndReturnError:&errDict];
    if (errDict) {
        NSLog(@"%@",errDict);
    }
}

-(NSArray *)URLs
{
    return [linkDict allValues];
}

-(void) processInput:(id) input
{
    SiteIndex index = [[[self parameters] valueForKey:@"selectedSite"] intValue];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

	NSEnumerator *enumerator = [(NSArray *)input objectEnumerator];
	NSString *referrer;

    while ((referrer = [enumerator nextObject])) 
    {
        AZ115URL *azURL = [[AZ115URL alloc] init];
        [azURL getURLsFrom115ApiWithURL:referrer];
        NSURL *downlink = [azURL URLWithSite:index];
        if(downlink) {
            NSString *ref = [NSString stringWithFormat:@"%@",referrer];
            [dict setObject:downlink forKey:ref];
        }
        [azURL release];
    }
    linkDict = [dict copy];
    [dict release];
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo
{
    DownloadTool downloadTool = [[[self parameters] valueForKey:@"downloadTool"] intValue];
    
    [self processInput:input];
    if (downloadTool) {
        switch (downloadTool) {
            case kiGetter:
                [self calliGetter];
                break;
                
            default:
                break;
        }
        
    }
    NSArray *output = [self URLs];
    [linkDict release];
	return output;
}

@end
