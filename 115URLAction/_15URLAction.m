//
//  _15URLAction.m
//  115URLAction
//
//  Created by sycx on 11-3-15.
//  Copyright 2011年 sycx. All rights reserved.
//

#import "_15URLAction.h"
#import "AZ115URL.h"

enum siteIndex { kChinaUnicomIndex, kChinaTelecomIndex, kBackupIndex};

@implementation _15URLAction

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo
{
    NSInteger index = [[[self parameters] valueForKey:@"selectedSite"] intValue];
    
    NSMutableArray *output = [NSMutableArray array];
	NSEnumerator *enumerator = [(NSArray *)input objectEnumerator];
	NSString *url;
    
    while ((url = [enumerator nextObject])) 
    {
        AZ115URL *azURL = [[AZ115URL alloc] init];
        [azURL getURLsFrom115ApiWithURL:url];
        if(azURL.isFounded)
            switch (index) {
                case kChinaUnicomIndex:
                    
                    [output addObject:[NSURL URLWithString:azURL.chinaUnicomString]];
                    break;
                case kChinaTelecomIndex:
                    [output addObject:[NSURL URLWithString:azURL.chinaTelecomString]];
                    break;
                case kBackupIndex:
                    [output addObject:[NSURL URLWithString:azURL.backupString]];
                    break;
                    
                default:
                    NSLog(@"No Found: %@",azURL.a115URLString);
                    break;
            }
        [azURL release];
    }
	return output;
}

@end
