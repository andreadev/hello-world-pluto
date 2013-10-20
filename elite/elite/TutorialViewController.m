//
//  TutorialViewController.m
//  elite
//
//  Created by Andrea Barbieri on 17/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "TutorialViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface TutorialViewController ()
@end


@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"intro");
    //NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"cacheProd"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    /*if (error)
        //NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    else
        //NSLog(@"CREATA CARTELLA");*/
    /*NSArray *paths = (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
    NSString *cacheDir = [paths objectAtIndex:0];
    
    BOOL isDirectory;
    
    
    
    NSString *cacheProd = [cacheDir stringByAppendingPathComponent:@"cacheProd"];
    
    if (![manager fileExistsAtPath:cacheProd isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
        [manager createDirectoryAtPath:cacheProd
           withIntermediateDirectories:YES
                            attributes:attr
                                 error:&error];
        if (error)
            //NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }*/
    
    //self.title=@"Prima";
    
    /*UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Next"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(nextButtonTapped)];
    
    self.navigationItem.rightBarButtonItem=nextButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Skip"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(skipButtonTapped)];
    
    self.navigationItem.leftBarButtonItem=backButton;*/
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    //NSLog(@"TUTORIAL");
    //NSLog(@"tento");
    
    //STEP 1 Construct Panels
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tut1"] title:@"" description:@""];
    
    //You may also add in a title for each panel
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tut2"] title:@"" description:@""];
    
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tut3"] title:@"" description:@""];
    
    //MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SampleImage2"] title:@"Carica la foto!" description:@"Consiglia a tutti!"];
    
    //STEP 2 Create IntroductionView
    
    /*A standard version*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
    
    
    /*A version with no header (ala "Path")*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2]];
    
    /*A more customized version*/
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"" panels:@[panel, panel2,panel3] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"SampleBackground"]];
    
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view];
}
#pragma mark - Sample Delegate Methods

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        //NSLog(@"Did Finish Introduction By Skipping It");
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate  presentLoginController];
        
    }
    else if (finishType == MYFinishTypeSwipeOut){
        //NSLog(@"Did Finish Introduction By Swiping Out");
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate  presentLoginController];
        
    }
    
    //One might consider making the introductionview a class variable and releasing it here.
    // I didn't do this to keep things simple for the sake of example.
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    //NSLog(@"%@ \nPanelIndex: %d", panel.Description, panelIndex);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) nextButtonTapped{
    //NSLog(@"Cambia immagine");
}
- (void) skipButtonTapped{
    //NSLog(@"Chiudi");
    [self.view removeFromSuperview];
    
}

@end
