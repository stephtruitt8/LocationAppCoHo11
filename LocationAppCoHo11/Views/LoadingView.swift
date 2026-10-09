//
//  LoadingView.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//

import SwiftUI

struct LoadingView:View {
    var body: some View {
        VStack{
            ProgressView().padding().tint(.blue)
            Text("Getting your location")
        }
    }
}

#Preview {
    LoadingView()
}
