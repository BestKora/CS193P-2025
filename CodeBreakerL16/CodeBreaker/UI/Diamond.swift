//
//  Diamond.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 5/28/25.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.closeSubpath()
        }
    }
    
    
}

#Preview {
    Diamond().stroke().aspectRatio(1, contentMode:.fit)
}
