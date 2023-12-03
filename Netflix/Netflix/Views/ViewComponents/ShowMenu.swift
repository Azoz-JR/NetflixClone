//
//  ShowMenu.swift
//  Netflix
//
//  Created by Azoz Salah on 03/12/2023.
//

import SwiftUI

struct ShowMenu: View {
    
    @EnvironmentObject var viewModel: NetflixViewModel
    
    let item: ItemViewModel
    
    var body: some View {
        if viewModel.isShowDownloaded(item: item) {
            Button(role: .destructive) {
                viewModel.deleteShow(item: item)
            } label: {
                Label("Remove", systemImage: "trash.fill")
            }
        } else {
            Button {
                viewModel.downloadShow(item: item)
            } label: {
                Label("Download", systemImage: "arrow.down.to.line")
            }
        }
    }
}

#Preview {
    ShowMenu(item: .example)
        .environmentObject(NetflixViewModel())
}
