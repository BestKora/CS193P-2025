//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/16/25.
//

import SwiftUI

struct PegChooser: View {
    
    // MARK: Data In
    let choices: [Peg]
    
    // MARK: Data Out Function
    var onChoose: ((Peg) -> Void)?

    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

#Preview {
    PegChooser(choices: [Color.red, .blue, .green, .yellow]) { peg in
        print("chose \(peg)")
    }
        .padding()
}
