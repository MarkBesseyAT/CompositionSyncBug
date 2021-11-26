//
//  FileInfoView.swift
//  CompositionSyncBug
//
//  Created by Mark Bessey on 11/26/21.
//

import SwiftUI
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
