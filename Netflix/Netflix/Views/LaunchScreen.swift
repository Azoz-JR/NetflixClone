//
//  LaunchScreen.swift
//  Netflix
//
//  Created by Azoz Salah on 02/12/2023.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State private var size = 0.8
    @State private var opacity = 0.8
    @State private var repetitionCounter = 0
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Image(.launch)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 150)
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        launchAnimation()
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchScreen()
        .environmentObject(NetflixViewModel())
}


extension LaunchScreen {
    func launchAnimation() {
        if repetitionCounter < 2 {
            if #available(iOS 17.0, *) {
                withAnimation(.easeIn(duration: 1)) {
                    self.size = 1
                    self.opacity = 1.0
                } completion: {
                    withAnimation(.easeOut(duration: 1)) {
                        self.size = 0.8
                        self.opacity = 0.8
                    } completion: {
                        repetitionCounter += 1
                        self.launchAnimation()
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
