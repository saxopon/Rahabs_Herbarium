//
//  ViewController.m
//  RahabsHerbarium


#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface ViewController() {
}

@property NSMutableDictionary *soundsDictionary;
@property (strong) IBOutlet UILabel *Display;
@property bool playingmusic;
@property (strong) NSTimer *clipTimer;
@property (strong) NSTimer *displayTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	_soundsDictionary = [NSMutableDictionary new];
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
-(void)updateDisplay {
	NSMutableString *display = [[NSMutableString alloc] init];
	for (NSString *key in _soundsDictionary) {
		AVAudioPlayer *thisPlayer = [_soundsDictionary objectForKey:key];
		[display appendString:key];
		[display appendFormat:@" %.01f", [thisPlayer duration] - [thisPlayer currentTime]];
		[display appendString:@"\n"];
	}
	[_Display setText:display];
}

- (IBAction)buttonClick:(id)sender {
	
	if (_playingmusic == true) {
		_playingmusic = false;
		for (NSString *key in _soundsDictionary) {
			[[_soundsDictionary objectForKey:key] stop];
		}
		[self updateButtonTitleStart];
		[_soundsDictionary removeAllObjects];
		[_clipTimer invalidate];
		[_displayTimer invalidate];
		[_Display setText:@""];
	}
	else {
		_playingmusic = true;
		[self updateButtonTitleStop];
		[self playRandomClip];
		self.clipTimer = [NSTimer scheduledTimerWithTimeInterval:14.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
		self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
	}
}

- (void)playClip:(NSString*)title {
	NSString *path = [NSString stringWithFormat:@"%@/%@.wav", [[NSBundle mainBundle] resourcePath], title];
	NSURL *soundUrl = [NSURL fileURLWithPath:path];
	AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
	[audioPlayer setDelegate:self];
	NSString *track = [NSString stringWithFormat:@"Clip: %@", title];
	[_soundsDictionary setValue:audioPlayer forKey:track];
	[audioPlayer prepareToPlay];
	[audioPlayer play];
	[self updateDisplay];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSString *deletableKey;
	for (NSString *key in _soundsDictionary) {
		if ([_soundsDictionary objectForKey:key] == player)
			deletableKey = key;
	}
	[_soundsDictionary removeObjectForKey:deletableKey];
}

-(void)playRandomClip
{
	int r = arc4random_uniform(49) + 1;
	[self playClip:[NSString stringWithFormat:@"%d", r]];
}

@end
