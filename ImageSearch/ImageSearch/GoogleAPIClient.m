//
//  GoogleAPIClient.m
//  ImageSearch
//
//  Created by Amantay on 04.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

#import "GoogleAPIClient.h"
#import "SearchImage.h"


static NSString* const googleAPI_ID=@"AIzaSyAXy0ONj4ZfZRCY7dZzX_Je8LjWtsjzkAw";
static NSString* const searchEngineID=@"005817413421002005175:llytmhk28gs";
static NSString* const baseURLString=@"https://www.googleapis.com/customsearch/v1?";

@interface GoogleAPIClient ()

@property(nonatomic, strong)NSURLSession* session;

@end

@implementation GoogleAPIClient

#pragma mark init

-(instancetype)init
{
    self=[super init];
    
    if(self)
    {
        self.session=
        [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return self;
}

-(NSMutableURLRequest*)baseRequestWithQuery:(NSString*)query
{
    //  Создание URI, путем склеивания URL к API с параметрами (API key, custom search engine id и search query)
    NSString* requestURLString=
    [NSString stringWithFormat:@"%@key=%@&cx=%@&q=%@", baseURLString, googleAPI_ID, searchEngineID, query];
    
    NSURL* requestURL=[NSURL URLWithString:requestURLString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    
    request.HTTPMethod = @"GET";
    
    [request setValue:@"application/json, text/json"
   forHTTPHeaderField:@"Accept"];
    
    [request setValue:@"application/json"
   forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

-(void)getSearchResultWithQuery:(NSString*)query
                        success:(GoogleAPIClientCallBack)successBlock
                          error:(GoogleAPIClientErrorCallBack)errorBlock
{
    NSMutableURLRequest* searchRequest=[self baseRequestWithQuery:query];
    
    //  Я использовал блоки для создания обратной связи.
    NSURLSessionDataTask* dataTask=[self.session dataTaskWithRequest:searchRequest
                                                   completionHandler:^(NSData* data,
                                                                       NSURLResponse* response,
                                                                       NSError* error)
                                    {
                                        //Поддерживаются только запросы на английском языке
                                        if(error)
                                        {
                                            //  Вызов блока с ошибкой в параметрах
                                            errorBlock(error);
                                        }
                                        
                                        else
                                        {
                                            NSError* jsonError=nil;
                                            
                                            SearchResult* result=[[SearchResult alloc]initWithData:data
                                                                                             error:&jsonError];
                                            
                                            
                                            if(jsonError)
                                            {
                                                //  Вызов блока с JSON-ошибкой в параметрах
                                                errorBlock(jsonError);
                                            }
                                            
                                            else
                                            {
                                                //  Я сразу скачиваю original image и thumbnail image в объект и помещаю его в массив.
                                                //  Использовал это, чтоб была возможность отключения спиннера в TableView при обратном вызове.
                                                NSMutableArray<SearchImage*>* resultArr=[[NSMutableArray alloc]init];
                                                
                                                for (ItemsModel* tempItem in result.items)
                                                {
                                                    SearchImage* tempImage=[[SearchImage alloc]init];
                                                    
                                                    SrcModel* tempImageSrc=[[SrcModel alloc]init];
                                                    
                                                    SrcModel* tempThumbnailSrc=[[SrcModel alloc]init];
                                                    
                                                    tempImageSrc=tempItem.pagemap.cse_image[0];
                                                    tempThumbnailSrc=tempItem.pagemap.cse_thumbnail[0];
                                                    
                                                    tempImage.image=[UIImage imageWithData:
                                                                     [NSData dataWithContentsOfURL:
                                                                      [NSURL URLWithString: tempImageSrc.src]]];
                                                    
                                                    tempImage.thumbnailImage=[UIImage imageWithData:
                                                                              [NSData dataWithContentsOfURL:
                                                                               [NSURL URLWithString: tempThumbnailSrc.src]]];
                                                    
                                                    tempImage.title=tempItem.title;
                                                    
                                                    //  Иногда приходили неполные JSON(без ссылок на изображения) или "битые" ссылки.
                                                    //  Исправил проверкой на наличие изображений.
                                                    //  По сути, просто исключал пустые из списка результатов.
                                                    if(tempImage.image==nil || tempImage.thumbnailImage==nil || tempImage.title==nil)
                                                    {
                                                        continue;
                                                    }
                                                    
                                                    [resultArr addObject:tempImage];
                                                }
                                                
                                                successBlock(resultArr);
                                            }
                                        }
                                    }];
    [dataTask resume];
}

@end
