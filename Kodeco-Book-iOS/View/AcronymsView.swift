//
//  AcronymsView.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct AcronymsView: View {
    @State private var acronyms: [Acronym] = []
    @State private var showCreateView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if acronyms.isEmpty {
                    ContentUnavailableView("No acronyms yet", systemImage: "character.magnify", description: Text("Create one over here"))
                } else {
                    List {
                        ForEach(acronyms) { acronym in
                            VStack(alignment: .leading) {
                                Text(acronym.short)
                                    .font(.system(size: 18))
                                    .bold()
                                Text(acronym.long)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showCreateView = true
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .navigationDestination(isPresented: $showCreateView, destination: {
                CreateAcronymView(showCreateView: $showCreateView)
            })
            .onAppear {
                Task { try await fetchAcronyms() }
            }
        }
    }
    
    func fetchAcronyms() async throws {
        let request = ResourceRequest<Acronym>(resourcePath: "acronyms")
        let resources = try await request.getAll()
        DispatchQueue.main.async {
            self.acronyms = resources
        }

    }
}

#Preview {
    AcronymsView()
}
