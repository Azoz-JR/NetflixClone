//
//  ComingSoonView.swift
//  Netflix
//
//  Created by Azoz Salah on 01/02/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComingSoonView: View {
    
    @EnvironmentObject var viewModel: NetflixViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    StackView(shows: viewModel.upcomingMovies)
                }
            }
            .navigationTitle("Coming Soon")
        }
        
    }
}

struct ComingSoonView_Previews: PreviewProvider {
    static var previews: some View {
        ComingSoonView()
            .environmentObject(NetflixViewModel())
            .preferredColorScheme(.dark)
    }
}
