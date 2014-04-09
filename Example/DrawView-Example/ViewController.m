//
//  ViewController.m
//  DrawView-Example
//
//  Created by Frank Michael on 4/8/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

#import "ViewController.h"
#import <DrawView.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () <UIActionSheetDelegate> {
    IBOutlet DrawView *drawingView;
}
- (IBAction)loadArchived:(id)sender;
- (IBAction)saveDrawing:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Drawing View";
    UIBarButtonItem *animateButton = [[UIBarButtonItem alloc] initWithTitle:@"Animate" style:UIBarButtonItemStylePlain target:drawingView action:@selector(animatePath)];
    self.navigationItem.rightBarButtonItem = animateButton;
    UIBarButtonItem *archivedButton = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadArchived:)];
    self.navigationItem.leftBarButtonItem = archivedButton;
    // Drawing view setup.
    [drawingView setBackgroundColor:[UIColor whiteColor]];
    [drawingView strokeColor:[UIColor blackColor]];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loadArchived:(id)sender{
    // Load an archived array of bezier paths
    UIBezierPath *bezPath = [UIBezierPath new];
    NSData *testPath = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"]];
    NSArray *paths = [NSKeyedUnarchiver unarchiveObjectWithData:testPath];
    for (UIBezierPath *path in paths){
        [bezPath appendPath:path];
    }
    // Display archived path.
    [drawingView setDebugBox:YES];
    [drawingView drawBezier:bezPath];
}
- (IBAction)saveDrawing:(id)sender{
    UIActionSheet *saveSheet = [[UIActionSheet alloc] initWithTitle:@"Save" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera Roll",@"UIImage",@"UIBezierPath", nil];
    [saveSheet showInView:self.view];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex){
        if (buttonIndex == 0){
            UIImage *drawingImage = [drawingView imageRepresentation];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:drawingImage.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                NSLog(@"%@",assetURL);
                NSLog(@"%@",error);
            }];
        }else if (buttonIndex == 1){
            UIImage *drawingImage = [drawingView imageRepresentation];
            NSLog(@"%@",drawingImage);
        }else if (buttonIndex == 2){
            UIBezierPath *path = [drawingView bezierPathRepresentation];
            NSLog(@"%@",path);
        }
    }
}
@end
