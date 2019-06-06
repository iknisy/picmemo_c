//
//  GridCollectionViewController.m
//  picmemo_c
//
//  Created by 陳昱宏 on 2019/5/22.
//  Copyright © 2019 Mike. All rights reserved.
//

#import "GridCollectionViewController.h"
#import "AppDelegate.h"
#import "GridCollectionViewCell.h"
#import "DetailViewController.h"
#import <Photos/Photos.h>
#import "picmemo_c+CoreDataModel.h"

@interface GridCollectionViewController ()

@end

@implementation GridCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
NSMutableArray *memoDetails = nil;
NSMutableArray *selectedItem = nil;
bool delFlag = NO;
@synthesize delbutton;
//此變數只在viewDidLoad使用，但必須在此宣告才能留存delegate屬性
NSFetchedResultsController *fetchRC = nil;

- (IBAction)newMemo:(id)sender{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"NewMemoNavigationController"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(IBAction)delAction:(id)sender{
//    執行delete
    if (delFlag) {
        if (selectedItem.count > 0){
//            刪除已選項目
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
            NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
            for (MemoDetail *i in selectedItem){
                [context deleteObject:i];
            }
            [appDelegate saveContext];
            
//            NSError *error = nil;
//            if(![managedObjectContext save:&error]) {
//                NSLog(@"Core Data deleting ERROR!! %@", error);
//            }else{
//                NSLog(@"CoreData deleted.");
//            }
        }
//        取消選取
        for (NSIndexPath *index in self.collectionView.indexPathsForSelectedItems) {
            [self.collectionView deselectItemAtIndexPath:index animated:NO];
        }
//        清空已選list
        [selectedItem removeAllObjects];
//        關閉多選模式
        delFlag = NO;
        self.collectionView.allowsMultipleSelection = NO;
        delbutton.tintColor = UIColor.blackColor;
    }else{
//        開啟多選模式
        delFlag = YES;
        self.collectionView.allowsMultipleSelection = YES;
        delbutton.tintColor = UIColor.redColor;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
//    讀取CoreData
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.persistentContainer.viewContext;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error = nil;
    
//    NSEntityDescription *entityDsecription = [NSEntityDescription entityForName:@"MemoDetail" inManagedObjectContext:managedObjectContext];
//    [fetchRequest setEntity:entityDsecription];
    NSFetchRequest *request = [MemoDetail fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *sorts = [NSArray arrayWithObjects:sortDescriptor, nil];
//    [fetchRequest setSortDescriptors:sorts];
    request.sortDescriptors = sorts;
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    controller.delegate = self;
    fetchRC = controller;
    
    if(![controller performFetch: &error]) {
        NSLog(@"Fetch ERROR! %@", error);
    }
    
    memoDetails = [[NSMutableArray alloc] init];
    [memoDetails addObjectsFromArray:controller.fetchedObjects];
//    [memoDetails addObjectsFromArray: [managedObjectContext executeFetchRequest:fetchRequest error:&error]];
//
//    if (error != nil) {
//        NSLog(@"Fetch ERROR! %@", error);
//    }
    selectedItem = [[NSMutableArray alloc] init];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    return memoDetails.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    // Configure the cell
//    設定cell的預覽圖
    if (memoDetails != nil) {
        MemoDetail *memo = [memoDetails objectAtIndex:indexPath.row];
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[memo.imageID] options:nil];
        [[PHImageManager defaultManager] requestImageForAsset:assets[0] targetSize:CGSizeMake(90, 72) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *image, NSDictionary *info){
            if(image != nil){
                cell.gridImageView.image = image;
            }
        }];
    }
//    設定cell的外框及被選擇後的外框
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-selected"]];
    return cell;
}

#pragma mart <NSFetchedResultControllerDelegate>

NSMutableArray *blockopration = nil;
- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    CoreData改變前初始化BlockOpration
    if (blockopration == nil) {
        blockopration = [[NSMutableArray alloc] init];
    }else{
        [blockopration removeAllObjects];
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//    CoreData改變時的動作
    NSBlockOperation *bo;
    switch (type) {
        case NSFetchedResultsChangeMove:{
            NSLog(@"CoreData Move.");
            bo = [NSBlockOperation blockOperationWithBlock:^{
                [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            }];
            break;
        }
        case NSFetchedResultsChangeDelete:{
            NSLog(@"CoreData Delete.");
            bo = [NSBlockOperation blockOperationWithBlock:^{
                [self.collectionView deleteItemsAtIndexPaths: [NSArray arrayWithObject: indexPath]];
            }];
            break;
        }
        case NSFetchedResultsChangeInsert:{
            NSLog(@"CoreData Insert.");
            bo = [NSBlockOperation blockOperationWithBlock:^{
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject: newIndexPath]];
                NSLog(@"collectionView Insert.");
            }];
            break;
        }
        case NSFetchedResultsChangeUpdate:{
            NSLog(@"CoreData Update.");
            bo = [NSBlockOperation blockOperationWithBlock:^{
                [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject: indexPath]];
            }];
            break;
        }
//        default:
//            break;
    }
    [blockopration addObject: bo];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//    "Section"改變時的動作 (nothing to do here)
    
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    CoreData改變後的動作
    if (blockopration.count > 0) {
        [self.collectionView performBatchUpdates:^{
            for (NSBlockOperation *bo in blockopration) {
                [bo start];
            }
//            重新讀取修改後的CoreData
            NSArray *fetchObjects = controller.fetchedObjects;
            [memoDetails setArray:fetchObjects];
        } completion: ^(BOOL finished) {
            [blockopration removeAllObjects];
        }];
    }
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (delFlag) {
//        多選模式開啟時，將選擇的項目加入List
        [selectedItem addObject:memoDetails[indexPath.row]];
    }else{
//        多選模式關閉時，推送一個Detail的View
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        DetailViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"MemoDetailViewController"];
        controller.memoDetails = memoDetails;
        controller.index = indexPath.row;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        [self showViewController:controller sender:nil];
    }
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    多選模式開啟時，將取消選擇的項目移出List
    if (delFlag) {
        [selectedItem removeObject:memoDetails[indexPath.row]];
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    點選cell時要不要推送segue的動作 (在此無segue)
    if (delFlag) {
        return NO;
    }
    return YES;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
