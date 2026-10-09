//
//  LocationReady.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//
import SwiftUI

struct LocationReady:View {
    
    let latText:String
    let lonText:String
    let onRefresh:()->Void
    let onSave:()->Void
    
    var body: some View {
        VStack(spacing: 12){
            VStack{
                Text("Latitude: "+latText)
                Text("Longitude: "+lonText)
                
                HStack{
                    Button("Refresh"){
                        self.onRefresh()
                        
                    }.buttonStyle(.glassProminent)
                    
                    Button("Save location"){
                        self.onSave()
                    }.buttonStyle(.bordered)
                }
            }
        }
    }
}
#Preview {
    LocationReady(latText: "112.22", lonText: "77.99", onRefresh: {}, onSave: {})
}
