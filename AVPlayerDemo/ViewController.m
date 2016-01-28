//
//  ViewController.m
//  AVPlayer
//
//  Created by apple on 2/27/14.
//  Copyright (c) 2014 iMoreApps Inc. All rights reserved.
//

#import "ViewController.h"
#import "PlayerViewController.h"
#import "MovieInfosViewController.h"

@interface ViewController () {
  NSArray *_files;
  NSArray *_networkfiles;
}

@end

@implementation ViewController

- (void)reloadFiles
{
  // Local files
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docPath = [paths objectAtIndex:0];
  NSLog(@"Document path: %@", docPath);
  
  NSArray *files = [[NSFileManager defaultManager]
                    contentsOfDirectoryAtPath:docPath error:NULL];
  
  NSMutableArray *mediaFiles = [NSMutableArray array];
  for (NSString *f in files) {
    NSString *extname = [[f pathExtension] lowercaseString];
    if ([@[@"mp4",@"mov",@"m4v",@"wav",@"flac",@"ape",@"wma",@"mp3",
           @"avi",@"wmv",@"rmvb",@"flv",@"f4v",@"swf",@"mkv",@"dat",@"vob",@"mts",@"ogg",@"mpg"] indexOfObject:extname] != NSNotFound) {
      [mediaFiles addObject:[docPath stringByAppendingPathComponent:f]];
    }
  }
  _files = mediaFiles;
  
  // Network files
  _networkfiles =
  @[
    @{@"url":@"rtsp://218.204.223.237:554/live/1/66251FC11353191F/e7ooqwcfbqjoo80j.sdp",@"title":@"RTSP Stream"},
    @{@"url":@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8", @"title":@"Live video"},
    
    // for MJPEG av format, we recommend that you pass the input av format name for the player.
    // because sometimes ffmpeg can not probe the av input format.
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
  
  self.navigationItem.rightBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"Open"
                                   style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(handleOpen:)];
  
  [self reloadFiles];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) {
    case 0:
      return _networkfiles.count;
    case 1:
      return _files.count;
    default:
      return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileTableCell" forIndexPath:indexPath];
  
  NSString *file = nil;
  
  switch (indexPath.section) {
    case 0:
      file = [_networkfiles objectAtIndex:indexPath.row][@"title"];
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
      break;
    case 1:
      file = [_files objectAtIndex:indexPath.row];
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
      break;
  }
  cell.textLabel.text = [file lastPathComponent];
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case 0:
      return @"Network streams";
    case 1:
      return @"Local files";
    default:
      return nil;
  }
}

#pragma mark - UITableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"showMoviePlayer"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    UIViewController *controller = segue.destinationViewController;
    if ([controller isKindOfClass:[PlayerViewController class]]) {
      PlayerViewController *playerController = (PlayerViewController *)controller;
      
      switch (indexPath.section) {
        case 0: {
          NSDictionary *infos = [_networkfiles objectAtIndex:indexPath.row];
          
          NSString *urlStr = infos[@"url"];
          urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          playerController.mediaURL = [NSURL URLWithString:urlStr];
          playerController.avFormatName = infos[@"avfmtname"];
          break;
        }
        case 1: {
          NSString *filePath = [_files objectAtIndex:indexPath.row];
          NSURL *url = [NSURL fileURLWithPath:filePath];
          playerController.mediaURL = url;
          break;
        }
      }
    }
  }
  else if ([segue.identifier isEqualToString:@"showMovieInfos"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    UIViewController *controller = segue.destinationViewController;
    if ([controller isKindOfClass:[MovieInfosViewController class]]) {
      MovieInfosViewController *infosController = (MovieInfosViewController *)controller;
      
      switch (indexPath.section) {
        case 0: {
          NSDictionary *infos = [_networkfiles objectAtIndex:indexPath.row];
          infosController.mediaURL = [NSURL URLWithString:infos[@"url"]];
          infosController.avFormatName = infos[@"avfmtname"];
          break;
        }
        case 1: {
          NSString *path = [_files objectAtIndex:indexPath.row];
          infosController.mediaURL = [NSURL fileURLWithPath:path];
          break;
        }
      }
    }
  }
}

- (IBAction)refresh:(id)sender {
  
  [self reloadFiles];
  [self.tableView reloadData];
}

- (void)handleOpen:(id)sender {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AV Source URL"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Open", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alertView show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
  UITextField *tf = [alertView textFieldAtIndex:0];
  
  tf.text =
  [[NSUserDefaults standardUserDefaults] stringForKey:@"last_url"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  UITextField *tf = [alertView textFieldAtIndex:0];
  
  if (buttonIndex != alertView.cancelButtonIndex) {
    [[NSUserDefaults standardUserDefaults] setObject:tf.text forKey:@"last_url"];
    
    PlayerViewController *playerController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"playerVC"];
    
    NSString *urlStr = [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    playerController.mediaURL = [NSURL URLWithString:urlStr];
    [self presentViewController:playerController animated:YES completion:^{
    }];
  }
}

@end
