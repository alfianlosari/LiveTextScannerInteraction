//
//  ContentView.swift
//  LiveTextMac
//
//  Created by Alfian Losari on 15/07/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = AppViewModel()
    
    var body: some View {
        if vm.isLiveTextSupported {
            mainView
        } else {
            Text("Your device doesn't support Live Text Interaction")
        }
    }
    
    @ViewBuilder
    private var mainView: some View {
        if let selectedImage = vm.selectedImage {
            ZStack(alignment: .topTrailing) {
                LiveTextView(image: selectedImage)
                Button {
                    vm.selectedImage = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                }
                .buttonStyle(.borderless)
                .padding()
            }
        } else {
            importView
        }
    }
    
    private var importView: some View {
        Button {
            vm.importImage()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray.opacity(0.5))
                .overlay {
                    VStack(spacing: 32) {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                        Text("Drag and drop image\n or\n Click to select")
                    }
                }
                .frame(maxWidth: 320, maxHeight: 320)
                .padding()
                .onDrop(of: ["public.file-url"], isTargeted: nil, perform: vm.handleOnDrop(providers:))
        }
        .buttonStyle(.borderless)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
