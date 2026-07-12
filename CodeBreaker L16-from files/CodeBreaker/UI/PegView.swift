//
//  PegView.swift
//  CodeBreaker
//

import SwiftUI

struct PegView: View {
    //MARK: Data In
    let peg: Peg
    
    //MARK: -   Body
    
    let pegShape = Diamond()
    
    var body: some View {
        pegShape
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(Color(hex: peg) ?? .clear)
    }
}

#Preview {
    PegView(peg: Color.blue.hex)
        .padding()
}
