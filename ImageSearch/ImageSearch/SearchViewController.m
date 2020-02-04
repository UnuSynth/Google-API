//
//  SearchViewController.m
//  ImageSearch
//
//  Created by Amantay on 04.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

#import "SearchViewController.h"
#import "GoogleAPIClient.h"
#import "SearchResult.h"
#import "SearchImage.h"
#import "CellForSearchResults.h"
#import "OriginalImageViewController.h"

static NSString* const cellReuseID=@"search-view-controller-cell-id";
static NSString* const segueID=@"segue-id-for-show-image";

@interface SearchViewController ()

@property(nonatomic, strong)SearchResult* searchResult;
@property(nonatomic, strong)GoogleAPIClient* APIClient;
@property(nonatomic, strong)NSMutableArray<SearchImage*>* resultsArray;
@property(nonatomic, strong)IBOutlet UIActivityIndicatorView* spinner;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.APIClient=[[GoogleAPIClient alloc]init];
    self.searchResult=[[SearchResult alloc]init];
    self.resultsArray=[[NSMutableArray alloc]init];
    self.spinner.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - search realization

-(IBAction)searchButtonTap:(id)sender
{
    //  Я решил представить поле ввода запроса в виде Alert'а
    UIAlertController* searchDialog=
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"Enter search query"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [searchDialog addTextFieldWithConfigurationHandler:^(UITextField* textField)
     {
         textField.placeholder=@"here";
     }];
    
    
    UIAlertAction* searchAction=[UIAlertAction actionWithTitle:@"Search"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     NSString* queryString=[[searchDialog textFields][0]text];
                                     
                                     // Параметр "q" в URI должен быть без пробелов. Решил эту проблему с помощью метода:
                                     queryString=
                                     [queryString stringByReplacingOccurrencesOfString:@" "
                                                                            withString:@""];
                                     
                                     //Запрос не должен быть нулевым
                                     if(queryString.length>0)
                                     {
                                         // Спиннер появляется и начинает крутиться (анимировать вращение) при загрузке результатов
                                         self.spinner.hidden=NO;
                                         [self.spinner startAnimating];
                                         
                                         [self.APIClient getSearchResultWithQuery:queryString
                                                                          success:^(NSArray<SearchImage*>* result)
                                          {
                                              //    Каждый раз, при запросе, результатов в массиве не должно быть,
                                              //    иначе новые будут добавлены поверх старых, поэтому происходит очищение массива
                                              [self.resultsArray removeAllObjects];
                                              
                                              [self.resultsArray addObjectsFromArray:result];
                                              
                                              //    UI-элементы должны обновляться в главной очереди (в главном потоке),
                                              //    поэтому происходит переключение с помощью GCD
                                              dispatch_async(dispatch_get_main_queue(),
                                                             ^{
                                                                 [self.tableView reloadData];
                                                                 
                                                                 self.spinner.hidden=YES;
                                                                 [self.spinner stopAnimating];
                                                             });
                                          }
                                          
                                          error:^(NSError *error)
                                          {
                                              //    Я не успел реализовать исключение "поломанных" JSON,
                                              //    поэтому результаты запроса не отобразятся
                                              UIAlertController* errorAlert=
                                              [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                  message:[NSString stringWithFormat:@"An error occurred while processing your request: %@\nTry another search query.", error.localizedDescription]
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                              
                                              UIAlertAction* okAction=
                                              [UIAlertAction actionWithTitle:@"OK"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action)
                                                                     {
                                                                         dispatch_async(dispatch_get_main_queue(),
                                                                                        ^{
                                                                                            self.spinner.hidden=YES;
                                                                                            [self.spinner stopAnimating];
                                                                                        });
                                                                     }];
                                              
                                              [errorAlert addAction:okAction];
                                              
                                              [self presentViewController:errorAlert
                                                                 animated:YES
                                                               completion:nil];
                                          }];
                                     }
                                     
                                     else
                                     {
                                         UIAlertController* emptyTextfieldError=
                                         [UIAlertController alertControllerWithTitle:@"You must write a search query!"
                                                                             message:@"Empty query"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
                                         
                                         UIAlertAction* okAction=[UIAlertAction actionWithTitle:@"OK"
                                                                                          style:UIAlertActionStyleDefault
                                                                                        handler:nil];
                                         
                                         [emptyTextfieldError addAction:okAction];
                                         
                                         [self presentViewController:emptyTextfieldError
                                                            animated:YES
                                                          completion:nil];
                                     }
                                 }];
    
    UIAlertAction* cancelAction=[UIAlertAction actionWithTitle:@"Cancer"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
    
    [searchDialog addAction:searchAction];
    [searchDialog addAction:cancelAction];
    
    [self presentViewController:searchDialog
                       animated:YES
                     completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //  Я решил отображать строчку "Press search button to start searching" в label'e ячейки,
    //  поэтому всегда будет хотя бы одна строка
    if(self.resultsArray.count==0)
    {
        return 1;
    }
    
    return self.resultsArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CellForSearchResults *cell = [self.tableView dequeueReusableCellWithIdentifier:cellReuseID
                                                                      forIndexPath:indexPath];
    
    if(self.resultsArray.count==0)
    {
        [cell setTitle:@"Press search button to start searching"
          andThumbnail:nil];
        
        return cell;
    }
    
    SearchImage* tempResult=self.resultsArray[indexPath.row];
    
    [cell setTitle:tempResult.title
      andThumbnail:tempResult.thumbnailImage];
    
    return cell;
}

#pragma mark - TableView Delegate

-           (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    
    if(self.resultsArray.count>0)
    {
        SearchImage* senderImage=self.resultsArray[indexPath.row];
        
        [self performSegueWithIdentifier:segueID
                                  sender:senderImage];
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue*)segue
                sender:(id)sender
{
    [super prepareForSegue:segue
                    sender:sender];
    
    if([segue.identifier isEqualToString:segueID])
    {
        OriginalImageViewController* imageController=segue.destinationViewController;
        
        SearchImage* imageObj=sender;
        
        imageController.titleText=imageObj.title;
        imageController.image=imageObj.image;
    }
}

@end
