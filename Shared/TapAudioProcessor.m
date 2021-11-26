//
//  TapAudioProcessor.c
//  CompositionSyncBug
//
//  Created by Mark Bessey on 11/17/21.
//

#include "TapAudioProcessor.h"

void initTap(MTAudioProcessingTapRef tap, void *clientInfo, void **tapStorageOut) {
    NSLog(@"initTap: %p", tap);
}

void finalizeTap(MTAudioProcessingTapRef tap) {
    NSLog(@"finalizeTap: %p", tap);
}

void prepareTap(MTAudioProcessingTapRef tap, CMItemCount maxFrames, const AudioStreamBasicDescription *processingFormat) {
    NSLog(@"unprepareTap: %p", tap);
}

void unprepareTap(MTAudioProcessingTapRef tap) {
    NSLog(@"unprepareTap: %p", tap);
}

void processAudio(MTAudioProcessingTapRef tap,
                      CMItemCount numberFrames,
                      MTAudioProcessingTapFlags flags,
                      AudioBufferList *bufferListInOut,
                      CMItemCount *numberFramesOut,
                  MTAudioProcessingTapFlags *flagsOut) {
    //NSLog(@"processAudio");
    CMTimeRange range;
    // retrieve audio samples, for "in-place processing"
    MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, &range, numberFramesOut);
    //CMTimeRangeShow(range);
    // go through each buffer
//    for (int i=0; i < bufferListInOut->mNumberBuffers; i++) {
//        AudioBuffer b = bufferListInOut->mBuffers[i];
//    }
}

MTAudioProcessingTapRef createAudioTap(void) {
    void *clientInfo = NULL;
    MTAudioProcessingTapRef tapOut = NULL;
    MTAudioProcessingTapCallbacks callbacks = {
        kMTAudioProcessingTapCallbacksVersion_0,
        clientInfo,
//        initTap,
//        finalizeTap,
//        prepareTap,
//        unprepareTap,
        NULL,
        NULL,
        NULL,
        NULL,
        processAudio
    };
    MTAudioProcessingTapCreate(NULL, &callbacks, kMTAudioProcessingTapCreationFlag_PreEffects, &tapOut);
    return tapOut;
}

AVMutableAudioMixInputParameters* parametersForTrack(AVAssetTrack *track) {
    AVMutableAudioMixInputParameters *params = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    params.audioTapProcessor = createAudioTap();
    return params;
}
