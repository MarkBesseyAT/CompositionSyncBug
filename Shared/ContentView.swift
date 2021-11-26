//
//  ContentView.swift
//  Shared
//
//  Created by Mark Bessey on 11/10/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var working:Bool = false
    @State private var progress:Float = 0
    @State private var progressTimer:Timer?
    @State private var useTap:Bool = false
    @State private var appModel:AppModel
    init(appModel:AppModel) {
        self.appModel = appModel
    }
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            Text("Movie Concatenator")
                .font(.title)
                .padding()
            GroupBox(label: Label("Sources", systemImage: "film")) {
                FileInfoView(url: $appModel.firstMovie, save: false)
                FileInfoView(url: $appModel.secondMovie, save: false)
            }
            .padding(.horizontal)
            Toggle("Use (passthrough) AudioTap", isOn: $useTap)
                .padding(.horizontal)
                
            GroupBox(label: Label("Destination", systemImage: "film")) {
                FileInfoView(url: $appModel.destination, save: true)
            }
            .padding(.horizontal)
            Button(action: {
                combineMovies()
            }) {
                if working {
                    Text("\(Int(progress*100))%")
                } else {
                    Text("Combine")
                }
            }
            .padding()
            .disabled(working)
        }
        .padding(.vertical)
    }
    func combineMovies() {
        working = true
        progress = 0.0
        print("Combining\n\(appModel.firstMovie)\nand\n\(appModel.secondMovie)\ninto\n\(appModel.destination)")
        let session = concatenateMovies(sources: [appModel.firstMovie, appModel.secondMovie], destination: appModel.destination, useTap: useTap)
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (t:Timer) in
            progress = session.progress
            if progress == 1.0 {
                working = false
                progressTimer?.invalidate()
                progressTimer = nil
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(appModel: AppModel())
            ContentView(appModel: AppModel())
                .previewDevice("iPad (9th generation)")
        }
    }
}

struct FileInfoView: View {
    @State private var placeholder:String = "file path"
    @Binding private var fileURL:URL
    private var useSavePanel:Bool
    init(url:Binding<URL>, save:Bool) {
        _fileURL = url
        useSavePanel = save
    }
    var body: some View {
        HStack {
            Text(fileURL.path)
                .truncationMode(.head)
                .lineLimit(1)
            Button(action: {
                selectFile()
            }) {
                Text("Browse...")
            }
            Button(action: {
                openFile()
            }) {
                Text("Open")
            }
        }
        .padding()
    }
    func selectFile()  {
#if os(macOS)
        guard let window:NSWindow = NSApp.keyWindow else {return}
        let panel = useSavePanel ? NSSavePanel():NSOpenPanel()
        panel.title = "Select file to combine"
        panel.message = "Select file to combine"
        panel.directoryURL = fileURL
        panel.beginSheetModal(for: window) { (response) in
            guard let url = panel.url else {return}
            fileURL = url.standardizedFileURL
        }
#else
        // TODO: implement this for iOS
#endif
    }
    
    func openFile() {
#if os(macOS)
        NSWorkspace.shared.open(fileURL)
#else
        // TODO: implement this for iOS
#endif
    }
}
