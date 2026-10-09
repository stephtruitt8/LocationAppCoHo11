//
//  FailedView.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//

import SwiftUI

struct FailedView:View {
    let message:String
    let onTryAgain:()->Void
    
    var body: some View {
        VStack{
            Text(message).foregroundStyle(.red)
            
            Button("Retry"){
                onTryAgain()
            }.buttonStyle(.glassProminent)
        }
    }
}
#Preview {
    FailedView(message: "Error", onTryAgain: {})
}
