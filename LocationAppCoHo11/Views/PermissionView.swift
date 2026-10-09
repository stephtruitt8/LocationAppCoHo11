//
//  PermissionView.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//

import SwiftUI

struct PermissionView:View {
    
    // Function that is coming from a parent
    let onEnable: () -> Void
    
    var body: some View {
        
        VStack(spacing:12){
            Text("We need the location to save a check-in")
                .multilineTextAlignment(.center)
            
            Button("Enable location"){
                self.onEnable()
            }.buttonStyle(.glassProminent)
        }
        
    }
}

#Preview {
    PermissionView(onEnable:{})
}
