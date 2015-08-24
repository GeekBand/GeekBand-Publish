//
//  BLOneViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLOneViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@interface BLOneViewController ()<UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView             *imageView;
    UIActivityIndicatorView *indicatorView;
    UIProgressView          *progressView;
    UIButton                *downloadButton;
    
    AVAudioPlayer           *audioPlayer;
    SystemSoundID           systemSoundId;
}

@end

@implementation BLOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"One";
    self.bgImageView.image = [UIImage imageNamed:@"bg1.png"];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 20) / 2, 90, 20, 20)];
    indicatorView.hidesWhenStopped = YES;
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview:indicatorView];
    
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 210, self.view.bounds.size.width - 20, 5)];
    progressView.progress = 0;
    [self.view addSubview:progressView];
    
    downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.frame = CGRectMake(10, 235, self.view.bounds.size.width - 20, 45);
    downloadButton.backgroundColor = [UIColor greenColor];
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downloadButton addTarget:self action:@selector(downloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadButton];
    
    UIButton *playMp3Button = [UIButton buttonWithType:UIButtonTypeCustom];
    playMp3Button.frame = CGRectMake(10, 300, 60, 40);
    playMp3Button.backgroundColor = [UIColor redColor];
    [playMp3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playMp3Button setTitle:@"MP3" forState:UIControlStateNormal];
    [playMp3Button addTarget:self action:@selector(playMp3ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playMp3Button];
    
    UIButton *playWavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playWavButton.frame = CGRectMake(80, 300, 60, 40);
    playWavButton.backgroundColor = [UIColor redColor];
    [playWavButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playWavButton setTitle:@"WAV" forState:UIControlStateNormal];
    [playWavButton addTarget:self action:@selector(playWavButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playWavButton];

    
    UIButton *playMp4Button = [UIButton buttonWithType:UIButtonTypeCustom];
    playMp4Button.frame = CGRectMake(150, 300, 60, 40);
    playMp4Button.backgroundColor = [UIColor redColor];
    [playMp4Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playMp4Button setTitle:@"MP4" forState:UIControlStateNormal];
    [playMp4Button addTarget:self action:@selector(playMp4ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playMp4Button];
    
    UIBarButtonItem *cameraButton
    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonClicked:)];
    self.navigationItem.rightBarButtonItem = cameraButton;
}

- (void)print10
{
    NSLog(@"------ > main thread = %@, current thread = %@", [NSThread mainThread], [NSThread currentThread]);
    for (int i = 0; i < 100000; i++) {
        NSLog(@"12345678923456789");
    }
    
//    [self performSelectorOnMainThread:(SEL) withObject:<#(id)#> waitUntilDone:<#(BOOL)#>]];
//    [self performSelector:<#(SEL)#> onThread:(NSThread *) withObject:<#(id)#> waitUntilDone:<#(BOOL)#> modes:<#(NSArray *)#>];
}

- (void)downloadButtonClicked:(id)sender
{
    NSLog(@"main thread = %@, current thread = %@", [NSThread mainThread], [NSThread currentThread]);
    [NSThread detachNewThreadSelector:@selector(print10) toTarget:self withObject:nil];
    //NSOperationQueue
    //NSOperation
    
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"------ > main thread = %@, current thread = %@", [NSThread mainThread], [NSThread currentThread]);
        
        for (int i = 0; i < 100000; i++) {
            NSLog(@"12345678923456789");
        }
    });
     */
}

- (void)playMp3ButtonClicked:(id)sender
{
    if (!audioPlayer) {
        NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"mp3" ofType:@"mp3"];
        NSURL *mp3Url = [[NSURL alloc] initFileURLWithPath:mp3Path];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3Url error:NULL];
        audioPlayer.numberOfLoops = -1;
        [audioPlayer prepareToPlay];
    }
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
    }else {
        [audioPlayer play];
    }
}

- (void)playWavButtonClicked:(id)sender
{
    if (!systemSoundId) {
        NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"wav" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:wavPath], &systemSoundId);
    }
    AudioServicesPlaySystemSound(systemSoundId);
}

- (void)playMp4ButtonClicked:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mp4" ofType:@"mp4"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
    [moviePlayerViewController.moviePlayer play];
}

- (void)cameraButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"从相册选取", @"拍摄新照片", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"从相册选取"]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }else if ([buttonTitle isEqualToString:@"拍摄新照片"]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
