//
//  ContentView.swift
//  Adhkar Watch App
//
//  Created by Mohamad Arnaout on 2025-05-01.
//

import SwiftUI

struct ContentView: View {
    // MARK: - State
    @State private var count = 0
    @State private var hapticOnSwipe = true
    @State private var hapticOnCycle = true
    @State private var beads = [0, 1, 2]
    @State private var topOffset: CGFloat = 0
    @State private var midOffset: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    @State private var beadOpacities: [Double] = [1.0, 1.0, 1.0] // Opacity for each bead

    // MARK: - Constants
    private let cycleCount = 33
    private let phrases = ["سبحان الله", "الحمد لله", "الله أكبر"]
    private let beadSize: CGFloat = 55
    private let spacing: CGFloat = 1
    private let midDuration: Double = 0.25
    private let slideDuration: Double = 0.15
    private let topDuration: Double = 0.3

    // MARK: - Computed
    private var phrase: String {
        let index = (count / cycleCount) % phrases.count
        return phrases[index]
    }
    private var inCycle: Int { count % cycleCount }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: -15) {  // Reduced spacing from 4 to 2
                Text(phrase)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 0)  // Reduced spacing between phrase and beads
                    .padding(.top, -40)

                HStack {
                    Text("\(count)")
                        .font(.title2)
                    Spacer()
                    Text("\(inCycle)")
                        .font(.title2)
                }
                .padding(.horizontal)

                ZStack(alignment: .top) {
                    Capsule()
                        .fill(Color.brown.opacity(0.6))
                        .frame(width: 2, height: beadSize * 3 + spacing * 2)

                    ForEach(0..<3) { pos in
                        beadView(at: pos)
                    }
                }
                .frame(height: beadSize * 3 + spacing * 2)
                .padding(.vertical, 0)  // Reduced padding
                .padding(.bottom, 20)

                VStack(spacing: 30) {  // Reduced spacing from 12 to 8
                    Button("Reset", action: reset)
                    Toggle("Swipe Haptic", isOn: $hapticOnSwipe)
                    Toggle("Cycle Haptic", isOn: $hapticOnCycle)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)  // Reduced padding
            }
        }
    }

    // MARK: - Bead View
    @ViewBuilder
    private func beadView(at position: Int) -> some View {
        Image("Bead")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: beadSize, height: beadSize)
            .opacity(beadOpacities[position])
            .offset(y: baseY(for: position) + offset(for: position))
            .gesture(position == 1 ? dragGesture : nil)
    }

    private func baseY(for position: Int) -> CGFloat {
        CGFloat(position) * (beadSize + spacing)
    }

    private func offset(for position: Int) -> CGFloat {
        switch position {
        case 0: return topOffset
        case 1: return midOffset
        default: return bottomOffset
        }
    }

    // MARK: - Drag Gesture
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { value in
                if value.translation.height > beadSize / 2 {
                    animateCycle()
                }
            }
    }

    // MARK: - Animation
    private func animateCycle() {
        // Step 1: Middle and bottom beads move down together, side by side
        withAnimation(.easeOut(duration: midDuration)) {
            midOffset = beadSize + spacing   // Middle bead moves to bottom bead's initial position
            bottomOffset = beadSize + spacing // Bottom bead moves further down
        }

        // Step 2: Bottom bead fades out while middle bead stays in place
        DispatchQueue.main.asyncAfter(deadline: .now() + midDuration) {
            withAnimation(.easeOut(duration: slideDuration)) {
                beadOpacities[2] = 0  // Only bottom bead fades out
            }
        }
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + midDuration) {
            beadOpacities[2] = 0  // Only bottom bead disappears instantly
        }*/

        // Step 3: Top bead drops to middle position
        DispatchQueue.main.asyncAfter(deadline: .now() + midDuration + slideDuration) {
            withAnimation(.easeOut(duration: topDuration)) {
                topOffset = beadSize + spacing
            }
        }

        // Step 4: Rotate beads and reset
        let total = midDuration + slideDuration + topDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + total) {
            let next = (beads[2] + 1) % cycleCount
            beads = [next, beads[0], beads[1]]
            topOffset = -(beadSize + spacing)
            midOffset = 0
            bottomOffset = 0
            beadOpacities = [1.0, 1.0, 1.0] // Reset opacities
            withAnimation(.easeOut(duration: topDuration)) {
                topOffset = 0
            }
            increment()
        }
    }

    // MARK: - Counter & Reset
    private func increment() {
        count += 1
        if hapticOnSwipe { HapticManager.play(.click) }
        if inCycle == 0 && count > 0 && hapticOnCycle {
            HapticManager.play(.success)
        }
    }

    private func reset() {
        count = 0
        beads = [0, 1, 2]
        topOffset = 0
        midOffset = 0
        bottomOffset = 0
        beadOpacities = [1.0, 1.0, 1.0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
