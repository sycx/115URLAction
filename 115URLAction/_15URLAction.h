//
//  _15URLAction.h
//  115URLAction
//
//  Created by sycx on 11-3-15.
//  Copyright 2011年 sycx. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface _15URLAction : AMBundleAction {
@private
    NSDictionary *linkDict;
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
