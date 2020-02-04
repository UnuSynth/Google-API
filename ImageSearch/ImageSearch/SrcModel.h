//
//  SrcModel.h
//  ImageSearch
//
//  Created by Amantay on 05.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

//  Я использовал JSONModel для представления пар "ключ-значение" в виде объектов. JSON, в моем случае,
//  приходит с большим количеством вложенностей, поэтому классов много.

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface SrcModel : JSONModel

@property(nonatomic)NSString* src;

@end

@protocol SrcModel

@end
