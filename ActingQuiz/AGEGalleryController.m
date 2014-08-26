//
//  AGEGalleryController.m
//  ActingQuiz
//
//  Created by Lukas Bischofberger on 8/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "AGEGalleryController.h"


@implementation AGEGalleryController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.userId = (int)[defaults integerForKey:@"user_id"];
    self.imageId = 0;
    
    FFActQuizAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchedPictureSetArray = [appDelegate getAllImageSets:[NSNumber numberWithInt: self.userId]];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .2; //seconds
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshView:)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.fetchedPictureSetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    
    AGECellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    PictureSet* record = [self.fetchedPictureSetArray objectAtIndex:indexPath.row];
    
    cell.image.contentMode = UIViewContentModeScaleAspectFit;
    cell.image.clipsToBounds = YES;
    [cell.image setImage: [UIImage imageWithData:record.image]];
    
    cell.age.text = [self clustertoage:[record.cluster intValue]];
    
    if (record.set) {
        cell.aged.contentMode = UIViewContentModeScaleAspectFit;
        cell.aged.clipsToBounds = YES;
        [cell.aged setImage: [UIImage imageWithData:record.aged]];
    } else {
        [cell.aged setImage: [UIImage imageNamed:@"avatar.jpg"]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    PictureSet* record = [self.fetchedPictureSetArray objectAtIndex:indexPath.row];
    
    if (record.set) {
        UIImage *img = [UIImage imageWithData:record.image];
        UIImage *aged = [UIImage imageWithData:record.aged];
        [self setAged: aged];
        [self setImage: img];
        [self setAge: [self clustertoage:[record.cluster intValue]]];
        
        if ([@"15" isEqualToString:[NSString stringWithFormat: @"%@", record.cluster]]) {
            [self setImageId: [NSNumber numberWithInt: [record.imageid intValue]]];
        }
        
        [self performSegueWithIdentifier:@"show_detail" sender:self];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            // get the cell at indexPath (the one you long pressed)
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do?"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:@"Delete pictures"
                                                            otherButtonTitles:@"Save aged picture", nil];
            actionSheet.tag = indexPath.row;
            [actionSheet showInView:self.collectionView];

        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    PictureSet* record = [self.fetchedPictureSetArray objectAtIndex:actionSheet.tag];
    
    if (buttonIndex == 0) {
        
        [self.managedObjectContext deleteObject:record];
        [self.collectionView reloadData];
        
    } else if (buttonIndex == 1) {
        if (record.set) {
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:record.aged],
                                           self, // send the message to 'self' when calling the callback
                                           NULL, // the selector to tell the method to call on completion
                                           NULL);
        }
        
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"show_detail"])
    {
        // Get reference to the destination view controller
        AGEDetailImageViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setAged: self.Aged];
        [vc setImage: self.Image];
        [vc setAge: self.Age];
        if (self.imageId!=0) {
            [vc setImageId: self.imageId];
            NSLog(@"aa%@",self.imageId);
        }
    }
}

-(void)refreshView:(UIRefreshControl *)refresh {
    
    
    //do something
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
	[self setSessionQueue:sessionQueue];
    
    for (int i=0; i<self.fetchedPictureSetArray.count; i++) {
        PictureSet* record = [self.fetchedPictureSetArray objectAtIndex:i];
        
        if (!record.set) {
            //start async downloading here
            dispatch_async(sessionQueue, ^{
                //download
                //get image face_id - cluster_id from server
                int cl = [record.cluster intValue];
                if (cl==15) {
                    cl = 14;
                }
                NSString *requestURL = [NSString stringWithFormat:@"%@getFace?face_id=%d&cluster_id=%d", serverUrl, [record.imageid intValue], cl];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        //do finish, set downloaded image in record
                        record.set = [NSNumber numberWithInt:1];
                        record.aged = [NSData dataWithData:UIImagePNGRepresentation(responseObject)];
                    
                        [self.collectionView reloadData];
                        NSError *error;
                        if (![self.managedObjectContext save:&error]) {
                            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                        }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
                
                [requestOperation start];
                              
            });
        }
    }
    
        [refresh endRefreshing];
    }



- (NSString*) clustertoage: (int) cluster {
    
    NSString *str;
    
    switch (cluster) {
        case 1:
            str = @"< 1";
            break;
        case 2:
            str = @"between 1 and 2";
            break;
        case 3:
            str = @"between 2 and 4";
            break;
        case 4:
            str = @"between 4 and 6";
            break;
        case 5:
            str = @"between 6 and 9";
            break;
        case 6:
            str = @"between 9 and 12";
            break;
        case 7:
            str = @"between 12 and 15";
            break;
        case 8:
            str = @"between 15 and 24";
            break;
        case 9:
            str = @"between 24 and 34";
            break;
        case 10:
            str = @"between 34 and 44";
            break;
        case 11:
            str = @"between 44 and 56";
            break;
        case 12:
            str = @"between 56 and 67";
            break;
        case 13:
            str = @"between 67 and 79";
            break;
        case 14:
            str = @"between 79 and 101";
            break;
        case 15:
            str = @"all ages";
            break;
        default:
            str = @"no valid age";
            break;
    }
    return str;
    
}


- (IBAction)save:(id)sender {
    
}

- (IBAction)delete:(id)sender {
}
@end
