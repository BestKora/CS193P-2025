//
//  GameList.swift
//  CodeBreaker
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker]
    
    //MARK: Data Owned by Me
    @State private var gameToEdit: CodeBreaker?
    
    init(sortBy: SortOption = .name, nameContains search: String = "",
         selection: Binding<CodeBreaker?>) {
        _selection = selection
        let lowercaseSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let completedOnly = sortBy == .completed
        let predicate = #Predicate<CodeBreaker> { game in
            (!completedOnly || game.isOver) &&
            (search.isEmpty || game.name.contains(lowercaseSearch) ||
             game.name.contains(capitalizedSearch))
        }
        switch sortBy {
        case .name:   _games = Query(filter: predicate, sort: \CodeBreaker.name)
        case .recent, .completed: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }

    
    enum SortOption: CaseIterable {
        case name
        case recent
        case completed
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            case .completed: "Completed"
            }
        }
    }
    
    var body: some View {
        List (selection: $selection){
            ForEach (games){ game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu{
                    editButton(for: game) // editing a game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game).tint(.accentColor) // editing a game
                }
        }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // editing the List of games
        }
        .onAppear{  addSampleGames() }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
        }
        .sheet(isPresented: showGameEditor){
           gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor : some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name,
                                               pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit ) {
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                    modelContext.insert(copyOfGameToEdit)
                } else {
                    modelContext.insert(copyOfGameToEdit)
                }
            }
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool> (
            get: {
                gameToEdit != nil
            },
            set: { newValue in
                if !newValue {
                    gameToEdit = nil
                }
            })
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let results = try? modelContext.fetchCount (fetchDescriptor), results == 0 {
                modelContext.insert(CodeBreaker(name: "Mastermind",
                                         pegChoices: [.red,.blue,.green,.yellow]))
                modelContext.insert(CodeBreaker(name: "Earth Tones",
                                         pegChoices: [.orange,.brown,.black,.yellow,.green]))
                modelContext.insert(CodeBreaker(name: "Undersea",
                                         pegChoices: [.blue,.indigo,.cyan]))
            }
    }
}

#Preview (traits: .swiftData){
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}

// search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalizedSearch)
