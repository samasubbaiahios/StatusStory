//
//  BlockBasedSelector.h
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 25/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlockBasedSelector : NSObject

@end

typedef void (^OBJCBlock)(id selector);

void class_addMethodWithBlock(Class class, SEL newSelector, OBJCBlock block);

NS_ASSUME_NONNULL_END
