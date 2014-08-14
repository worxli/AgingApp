//
//  AGECollectionViewController.m
//  Aging
//
//  Created by Lukas Bischofberger on 7/8/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import "AGECollectionViewController.h"

@interface AGECollectionViewController ()

@end

@implementation AGECollectionViewController

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
    
    _ageImages = [[NSMutableArray alloc] init];
    _ageLabels = [[NSMutableArray alloc] init];
    _cropImages = [[NSMutableArray alloc] init];
    
    [_ageImages addObject:self.origImage];
    [_cropImages addObject:self.origImage];
    [_ageLabels addObject:[NSString stringWithFormat:@"Your age %@", self.age]];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@getCroppedFace?face_id=%d", serverUrl, (int)self.faceId];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //set image in collection view
            [self loadAgedImages:responseObject];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
    }];
    
    [requestOperation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadAgedImages: (UIImage*) cropped
{
    
    dispatch_queue_t queue = dispatch_queue_create("Download Queue",NULL);
    
    for (int i=(int)self.minCluster+1; i<=14; i++) {
        dispatch_async(queue, ^{
            
            //get image face_id - cluster_id from server
            NSString *requestURL = [NSString stringWithFormat:@"%@getFace?face_id=%d&cluster_id=%d", serverUrl, (int)self.faceId, i];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //set image in collection view
                    //[_ageClusters addObject:[NSNumber numberWithInt:i]];
                    [_ageImages addObject:responseObject];
                    [_ageLabels addObject:[NSString stringWithFormat:@"Approx. age %@", [self clustertoage:i]]];
                    [_cropImages addObject:cropped];
                    
                    [self.collectionView reloadData];
                });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //abort?
 
                });
            }];
            
            [requestOperation start];
        });
    }
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
        default:
            str = @"no valid age";
            break;
    }
    return str;
    
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return _ageImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    
    AGECellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    cell.cellImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.cellImage.clipsToBounds = YES;
    cell.cellImage.image = _ageImages[row];
    
    cell.cropImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.cropImage.clipsToBounds = YES;
    cell.cropImage.image = _cropImages[row];
    
    cell.cellLabel.text = _ageLabels[row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    long row = [indexPath row];
    [self setDetailImage:_ageImages[row]];
    
    [self performSegueWithIdentifier:@"fullImageAction" sender:self];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"fullImageAction"])
    {
        // Get reference to the destination view controller
        AGEDetailImageViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setDetailImage: self.detailImage];
    }
}


@end
