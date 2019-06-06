//
//  NewMemoTableViewController.m
//  picmemo_c
//
//  Created by 陳昱宏 on 2019/5/25.
//  Copyright © 2019 Mike. All rights reserved.
//

#import "NewMemoTableViewController.h"
#import "AppDelegate.h"
#import "picmemo_c+CoreDataModel.h"
#import <Photos/Photos.h>

@interface NewMemoTableViewController ()

@end

@implementation NewMemoTableViewController

@synthesize photoImageView;
@synthesize timeTextField;
@synthesize describTextView;
@synthesize photoID;

-(IBAction)backView:(id)sender{
//    返回前一頁
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)saveButton:(id)sender{
//    新增CoreData項目
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.persistentContainer.viewContext;
    NSManagedObject *newMemo = [NSEntityDescription insertNewObjectForEntityForName:@"MemoDetail" inManagedObjectContext:managedObjectContext];
    NSError *error;
    [newMemo setValue:timeTextField.text forKey:@"time"];
    [newMemo setValue:describTextView.text forKey:@"describe"];
    [newMemo setValue:[NSKeyedArchiver archivedDataWithRootObject:UIColor.whiteColor requiringSecureCoding:NO error:&error] forKey:@"textColor"];
    [newMemo setValue:photoID forKey:@"imageID"];
    
    [managedObjectContext save:&error];
    NSLog(@"CoreData saved.");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    點擊圖片欄後，可讓使用者選擇使用相機或從相簿選取
    if (indexPath.row == 1) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                default
//                picker.allowsEditing = NO;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }];
        UIAlertAction *photolibraryAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                default
//                picker.allowsEditing = NO;
//                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }];
        UIAlertController *photoActionController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [photoActionController addAction:cameraAction];
        [photoActionController addAction:photolibraryAction];
        [self presentViewController:photoActionController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    PHAsset *asset = info[UIImagePickerControllerPHAsset];
    photoID = asset.localIdentifier;
//        選取圖片後的載入動作
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *image, NSDictionary *info){
        if (image != nil){
            self.photoImageView.image = image;
            self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.photoImageView.clipsToBounds = YES;
            
            [NSLayoutConstraint constraintWithItem:self.photoImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.photoImageView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:self.photoImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.photoImageView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:self.photoImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.photoImageView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:self.photoImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.photoImageView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
        }
    }];
//        讀取檔案建立日期，並顯示在Time欄位
    NSDate *date = asset.creationDate;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"YYYY / MM / dd, HH:mm:ss";
    self.timeTextField.text = [format stringFromDate:date];
//    關閉選取照片頁面，回到上一頁
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
////#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
