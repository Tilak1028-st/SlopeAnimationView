//
//  SlopeAnimationView.swift
//  SlopeAnimationView
//
//  Created by Tilak Shakya on 22/07/24.
//

import SwiftUI

struct SlopeAnimationView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    // Slope path
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height

                        path.move(to: CGPoint(x: width * 0.1, y: height * 0.8))
                        path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.2))
                    }
                    .stroke(Color.gray, lineWidth: 2)

                    // Moving ball along the slope
                    MovingBall(isAnimating: isAnimating)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .padding()

            Button("Animate") {
                withAnimation(.linear(duration: 4).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
            .padding()
        }
    }
}

struct MovingBall: View {
    var isAnimating: Bool

    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(Color.blue)
                .frame(width: 30, height: 30)
                .modifier(SlopeAnimationModifier(isAnimating: isAnimating, size: geometry.size))
        }
    }
}

struct SlopeAnimationModifier: AnimatableModifier {
    var isAnimating: Bool
    var size: CGSize

    var animatableData: CGFloat {
        get { isAnimating ? 1 : 0 }
        set { _ = newValue }
    }

    func body(content: Content) -> some View {
        let progress = isAnimating ? 1.0 : 0.0
        let startPoint = CGPoint(x: size.width * 0.1, y: size.height * 0.8)
        let endPoint = CGPoint(x: size.width * 0.9, y: size.height * 0.2)
        
        let currentX = startPoint.x + (endPoint.x - startPoint.x) * progress
        let currentY = startPoint.y + (endPoint.y - startPoint.y) * progress
        
        return content
            .position(x: currentX, y: currentY)
    }
}

#Preview {
    SlopeAnimationView()
}


