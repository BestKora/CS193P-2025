//
//  GameChooser.swift
//  CodeBreaker
//

import SwiftUI

struct GameChooser: View {
    @State private var selection: CodeBreaker? = nil
    @State private var sortOption: GameList.SortOption = .name
    @State private var search: String = ""
    
    var body: some View {
        NavigationSplitView(columnVisibility:.constant(.all)) {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameList(sortBy: sortOption, nameContains: search, selection: $selection)
                .navigationTitle("Code Breaker")
                .searchable(text: $search)
                .animation(.easeOut, value: search)
        }
       detail: {
           if let selection {
               CodeBreakerView(game: selection)
                   .navigationTitle(selection.name)
                   .navigationBarTitleDisplayMode(.inline)
           } else {
               Text("Choose a game!")
           }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview (traits: .swiftData){
    GameChooser()
}

