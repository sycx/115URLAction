//
//  _15URLAction.m
//  115URLAction
//
//  Created by sycx on 11-3-15.
//  Copyright 2011年 sycx. All rights reserved.
//

#import "_15URLAction.h"
#import "AZ115URL.h"

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
        NSURL *downlink = [azURL URLWithSite:index];
        if(downlink) {
            [output addObject:downlink];
        }
        [azURL release];
    }
	return output;
}

@end
