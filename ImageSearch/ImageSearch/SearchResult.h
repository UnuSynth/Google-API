//
//  SearchResult.h
//  ImageSearch
//
//  Created by Amantay on 05.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsModel.h"

@interface SearchResult : JSONModel

@property(nonatomic, strong)NSArray<ItemsModel>* items;

@end
