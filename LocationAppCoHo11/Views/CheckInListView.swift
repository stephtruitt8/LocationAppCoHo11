//
//  CheckInListView.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//

import SwiftUI

struct CheckInListView:View {
    
    let checkInlist:[CheckIn]
    let onClear:()->Void
    
    var body: some View {
        VStack{
            HStack{
                Text("Check-ins").font(.headline)
                
                Button("Clear all"){
                    onClear()
                }.disabled(checkInlist.count == 0)
            }
            
            if checkInlist.count == 0 {
                Text("No Check in")
            }else{
                List(checkInlist) { item in
                    VStack{
                        
                        Text("Lat: \(String(format: "%.4f",item.latitude))")
                        Text("Long: \(String(format: "%.4f",item.longitude))")
                        HStack{
                            Text(item.timestamp,style: .date)
                            Text(item.timestamp,style: .time)
                        }.padding()
                    }
                    
                }
            }
        }
        
    }
}

#Preview {
    CheckInListView(checkInlist: [CheckIn(latitude: 123.44, longitude: 123.32, timestamp: .now)], onClear: {})
}
