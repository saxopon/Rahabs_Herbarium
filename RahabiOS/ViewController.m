//
//  ViewController.m
//  RahabsHerbarium


#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface ViewController() {
}

@property NSMutableArray *soundsArray;
@property (strong) IBOutlet UILabel *Display;
@property bool playingmusic;
@property (strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	_soundsArray = [NSMutableArray new];
}

-(void)timer:(NSTimer*)t
{
	[self playRandomClip];
}

-(void)updateButtonTitleStop {
	[self.Button setTitle:@"Stop" forState:UIControlStateNormal];
}
-(void)updateButtonTitleStart {
	[self.Button setTitle:@"Start" forState:UIControlStateNormal];
}

- (IBAction)buttonClick:(id)sender {
	
	if (_playingmusic == true) {
		_playingmusic = false;
		for (AVAudioPlayer *a in _soundsArray) [a stop];
		[self updateButtonTitleStart];
		[_soundsArray removeAllObjects];
		[_timer invalidate];
	}
	else {
		_playingmusic = true;
		[self updateButtonTitleStop];
		[self playRandomClip];
		self.timer = [NSTimer scheduledTimerWithTimeInterval:14.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
	}
}

- (void)playClip:(NSString*)title {
	NSString *path = [NSString stringWithFormat:@"%@/%@.wav", [[NSBundle mainBundle] resourcePath], title];
	NSURL *soundUrl = [NSURL fileURLWithPath:path];
	AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
	[audioPlayer setDelegate:self];
	[_soundsArray addObject:audioPlayer];
	[audioPlayer prepareToPlay];
	[audioPlayer play];
	[_Display setText:[NSString stringWithFormat:@"Clip: %@ \t %.01f", title, [audioPlayer duration]]];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[_soundsArray removeObject:player];
}

-(void)playRandomClip
{
	int r = arc4random_uniform(49) + 1;
	[self playClip:[NSString stringWithFormat:@"%d", r]];
	NSLog(@"Clip %d", r);
	NSLog(@"%@", _soundsArray);

}

@end
