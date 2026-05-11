//
//  GameList.swift
//  CodeBreaker
//

import SwiftUI

struct GameList: View {
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    
    //MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    @State private var gameToEdit: CodeBreaker?
    
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
                games.remove(atOffsets: offsets)
            }
            .onMove { offsets, destination in
                games.move(fromOffsets: offsets, toOffset: destination)
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
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert( gameToEdit, at: 0)
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
                games.removeAll { $0 == game }
            }
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red,.blue,.green,.yellow]))
            games.append(CodeBreaker(name: "Earth Tones",
                                     pegChoices: [.orange,.brown,.black,.yellow,.green]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue,.indigo,.cyan]))
            selection = games[Int.random(in: 0..<games.count)]
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}

