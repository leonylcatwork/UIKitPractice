//
//  Category.h
//  UIKitPractice
//
//  Created by leon on 20/07/2018.
//  Copyright © 2018 Maimemo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"


@interface Category : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray <Book *> *books;


@end
