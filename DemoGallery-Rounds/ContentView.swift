//
//  ContentView.swift
//  DemoGallery-Rounds
//

import SwiftUI

struct ContentView: View {
    @State private var model = GalleryViewModel()
    /// Drives `loadList` from the root `.task`; bump to retry after failure (cancels in-flight load).
    @State private var listLoadAttempt = 0
    /// Drives cache invalidation from `.task`; bump on toolbar tap. `0` means “do not clear on first task run”.
    @State private var cacheClearGeneration = 0

    private var isLoadingEmptyList: Bool {
        model.entries.isEmpty && (model.phase == .idle || model.phase == .loading)
    }

    private var isLoadedAndEmpty: Bool {
        model.phase == .loaded && model.entries.isEmpty
    }

    var body: some View {
        NavigationStack {
            Group {
                if case .failed(let message) = model.phase, model.entries.isEmpty {
                    ContentUnavailableView {
                        Label("Couldn’t load list", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Retry") {
                            listLoadAttempt += 1
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if isLoadingEmptyList {
                    ProgressView("Loading…")
                } else if isLoadedAndEmpty {
                    ContentUnavailableView {
                        Label("No images", systemImage: "photo.on.rectangle.angled")
                    } description: {
                        Text("The catalog is empty. Pull down to refresh.")
                    } actions: {
                        Button("Reload") {
                            listLoadAttempt += 1
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(model.entries) { entry in
                                GalleryCard(item: entry.item, imageRefreshEpoch: model.imageRefreshEpoch)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .refreshable {
                        await model.loadList()
                    }
                }
            }
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        cacheClearGeneration += 1
                    } label: {
                        Label("Clear cache", systemImage: "trash")
                    }
                    .disabled(model.entries.isEmpty)
                }
            }
            .task(id: listLoadAttempt) {
                await model.loadList()
            }
            .task(id: cacheClearGeneration) {
                guard cacheClearGeneration > 0 else { return }
                await model.clearImageCache()
            }
        }
    }
}

#Preview {
    ContentView()
}
