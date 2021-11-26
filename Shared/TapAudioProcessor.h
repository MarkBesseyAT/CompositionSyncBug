//
//  TapAudioProcessor.h
//  CompositionSyncBug
//
//  Created by Mark Bessey on 11/17/21.
//

#ifndef TapAudioProcessor_h
#define TapAudioProcessor_h

#include <MediaToolbox/MediaToolbox.h>
#import <AVFoundation/AVFoundation.h>

AVMutableAudioMixInputParameters* parametersForTrack(AVAssetTrack *track);
#endif /* TapAudioProcessor_h */
