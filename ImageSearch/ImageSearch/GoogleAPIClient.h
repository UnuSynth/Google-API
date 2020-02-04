//
//  GoogleAPIClient.h
//  ImageSearch
//
//  Created by Amantay on 04.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResult.h"
#import "SearchImage.h"

typedef void(^GoogleAPIClientCallBack)(NSArray<SearchImage*>* result);
typedef void(^GoogleAPIClientErrorCallBack)(NSError* error);


@interface GoogleAPIClient : NSObject

-(void)getSearchResultWithQuery:(NSString*)query
                        success:(GoogleAPIClientCallBack)successBlock
                          error:(GoogleAPIClientErrorCallBack)errorBlock;

@end
