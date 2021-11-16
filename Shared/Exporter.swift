//
//  Exporter.swift
//  ExportSync
//
//  Created by Mark Bessey on 11/12/21.
//

import Cocoa
import AVFoundation

/// Concatenate two movies
///
func concatenateMovies(sources: [URL], destination: URL) -> AVAssetExportSession {
    // create composition
    let composition = AVMutableComposition()
    var insertTime = CMTime(value: 0, timescale: 30)
    var instructions:[AVVideoCompositionInstructionProtocol] = []
    var videoSize = CGSize.zero
    // iterate over sources
    for source in sources {
        // create 2 composition tracks for each source (one video, one audio)
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let path = source.path
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        let assetVideoTrack = asset.tracks(withMediaType: .video).first!
        // set the output size to the first video's naturalSize
        if (videoSize.width.isZero) {
            videoSize = assetVideoTrack.naturalSize
        }
        let assetAudioTrack = asset.tracks(withMediaType: .audio).first!
        let audioRange = assetAudioTrack.timeRange
        let videoRange = assetVideoTrack.timeRange
        // These ranges are often different.
        if !CMTimeRangeEqual(audioRange, videoRange) {
            print("Ranges not equal audio=\(audioRange), video = \(videoRange)")
        }
        // composition instructions
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: insertTime, duration: videoRange.duration)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
        instruction.layerInstructions = [layerInstruction]
        instructions.append(instruction)
        
        // insert tracks
        try! compositionVideoTrack?.insertTimeRange(videoRange, of: assetVideoTrack, at: insertTime)
        try! compositionAudioTrack?.insertTimeRange(audioRange, of: assetAudioTrack, at: insertTime)
        // There cannot be any gaps between the video tracks, or the composition will fail, so we will
        // insert the next video segment directly after the first.
        // It turns out not to matter if there are gaps or overlap in the audio tracks, because
        // AVAudioMix does something sensible in those cases.
        insertTime = CMTimeAdd(insertTime, videoRange.duration)
    }
    composition.naturalSize = videoSize
    let videoComposition = AVMutableVideoComposition()
    videoComposition.instructions = instructions
    videoComposition.renderSize = videoSize
    videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
    dumpComposition(composition: composition)
    
    // start export session
    let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPreset640x480)!
    exportSession.outputURL = destination
    // remove output file, if it exists
    if FileManager.default.fileExists(atPath: destination.path) {
        do {
            try FileManager.default.removeItem(atPath: destination.path)
        } catch {
            
        }
    }
    // set output parameters
    exportSession.outputFileType = .mp4
    exportSession.shouldOptimizeForNetworkUse = true
    exportSession.videoComposition = videoComposition
    exportSession.audioMix = AVAudioMix()
    exportSession.exportAsynchronously {
        if (exportSession.status == .completed) {
            print("done")
        } else {
            print(exportSession.status)
            print(exportSession.error!)
        }
    }
    return exportSession
}

func dumpComposition(composition: AVComposition) {
    var dump:String = ""
    for track:AVCompositionTrack in composition.tracks {
        guard let mutableTrack = track as? AVMutableCompositionTrack else {
            return
        }
        dump += "track: \(track)\n"
        for segment:AVCompositionTrackSegment in track.segments {
            dump += "\tsegment: \(segment)\n"
        }
        do {
            try mutableTrack.validateSegments(track.segments)
        } catch {
            print("failed validation!")
        }
    }
    print(dump)
}
