//
//  ViewController.m
//  AVPlayer
//
//  Created by apple on 2/27/14.
//  Copyright (c) 2014 iMoreApps Inc. All rights reserved.
//

#import "ViewController.h"
#import "PlayerViewController.h"

@interface ViewController () {
  NSArray *_avsources;
}

@end

@implementation ViewController

- (void)reloadFiles
{
  // Network files
  _avsources =
  @[
    @{@"url":@"rtsp://218.204.223.237:554/live/1/66251FC11353191F/e7ooqwcfbqjoo80j.sdp",@"title":@"RTSP Stream"},
    @{@"url":@"rtmp://edge01.fms.dutchview.nl/botr/bunny.flv",@"title":@"rtmp://Bunny.FLV"},
    @{@"url":@"http://10.0.1.28/2.avi",@"title":@"Local HTTP Stream"},
    @{@"url":@"http://mp3.streampower.be/radio1.aac", @"title":@"HTTP audio"},
    @{@"url":@"https://mvvideo5.meitudata.com/571090934cea5517.mp4", @"title":@"HTTPs video"},
    @{@"url":@"http://cascam.ou.edu/axis-cgi/mjpg/video.cgi?resolution=320x240", @"title":@"mjpeg video",
      @"avfmtname":@"mjpeg"},
    @{@"url":@"http://webcam.st-malo.com/axis-cgi/mjpg/video.cgi?resolution=352x288", @"title":@"Live Camera video",
      @"avfmtname":@"mjpeg"},
    ];
  
  [self.tableView reloadData];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                target:self action:@selector(reloadFiles)];
  
  [self reloadFiles];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _avsources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileTableCell" forIndexPath:indexPath];
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [_avsources objectAtIndex:indexPath.row][@"title"];
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"showMoviePlayer"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    UIViewController *controller = segue.destinationViewController;
    
    if ([controller isKindOfClass:[PlayerViewController class]]) {
      PlayerViewController *playerController = (PlayerViewController *)controller;
      
      NSDictionary *infos = [_avsources objectAtIndex:indexPath.row];
      playerController.mediaURL = [NSURL URLWithString:infos[@"url"]];
      playerController.avFormatName = infos[@"avfmtname"];
    }
  }
}

- (IBAction)refresh:(id)sender {
  
  [self reloadFiles];
  [self.tableView reloadData];
}

@end
