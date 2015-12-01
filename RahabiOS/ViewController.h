//
//  ViewController.h
//  RahabiOS
//
//  Created by Elektra Wrenholt on 11/26/15.
//  Copyright © 2015 saxopon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController < AVAudioPlayerDelegate >

@property (strong, nonatomic) IBOutlet UIButton *Button;

- (IBAction)buttonClick:(id)sender;

@end

