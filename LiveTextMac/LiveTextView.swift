//
//  LiveTextView.swift
//  LiveTextMac
//
//  Created by Alfian Losari on 15/07/22.
//

import Foundation
import SwiftUI
import VisionKit

@MainActor
struct LiveTextView: NSViewRepresentable {
    
    let image: NSImage
    let imageView = LiveTextImageView()
    let overlayView = ImageAnalysisOverlayView()
    let analyzer = ImageAnalyzer()
    
    func makeNSView(context: Context) -> some NSView {
        imageView.image = image
        overlayView.preferredInteractionTypes = .automatic
        overlayView.autoresizingMask = [.width, .height]
        overlayView.frame = imageView.bounds
        overlayView.trackingImageView = imageView
        imageView.addSubview(overlayView)
        return imageView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        guard let image = imageView.image else { return }
        Task { @MainActor in
            do {
                let configuration = ImageAnalyzer.Configuration([.text])
                let analysis = try await analyzer.analyze(image, orientation: .up, configuration: configuration)
                overlayView.analysis = analysis
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}


class LiveTextImageView: NSImageView {
    
    override var intrinsicContentSize: NSSize {
        .zero
    }
}
