# CompositionSyncBug
Quick demonstration of an AVMutableComposition and AVExportSession synchronization issue

**What the code does**
This code does the following:
1. Loads two video files
2. Creates an AVMutableComposition
3. Adds an audio and video track to the composition for each video
  1. The first video starts at timestamp 0.0 
  2. The second video starts at the duration of the first video
4. Adds an AVMutableVideoCompositionLayerInstruction to select the correct video track for each time range
5. Uses AVAssetExportSession to save the composition to a file

The useful code is all in Exporter.swift,in the concatenateMovies() function. 

**Expected Result:**
Audio and Video content should be exported in sync

**Actual Results:**
There are three movie files included with the project:
1. A five-minute video of a countdown timer, with a 48KHz audio track
2. A One-minute video, with a 16KHz audio track
3. A One-minute video, with an 8 KHz audio track

When combining the 48KHz file and the 16KHz file, the audio on the second clip will be **delayed** by about one second.  

When combining the 48KHz and 8KHz files, the audio for the second clip will **overlap** the audio on the first clip by several seconds.

**Additional notes:**
* When combining two files with the same audio rate, this error isn't observed.
* In cases where the audio rates are very close (e.g. 48KHz and 44.1KHz) the effect is much reduced.
* The longer the first movie file is, the more-noticeable the offset is.
* The iOS version is not feature-complete, but does at least do the basic composition. The same behavior is seen when running via Mac Catalyst
