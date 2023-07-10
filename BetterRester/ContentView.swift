//
//  ContentView.swift
//  BetterRester
//  DAY26 / 100DaysOfSwiftUI by @TwoStraws PaulHudson
//  Student: yannemal on 09/07/2023.
//

import SwiftUI

struct ContentView: View {
    // MARK: - DATA
    @State private var wakeUp  = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        
        NavigationView {
         
            VStack {
                Text("When do you want to wake up ?")
                    .font(.headline)
                
                DatePicker("Please enter a time",
                           selection: $wakeUp,
                           displayedComponents: .hourAndMinute)
                .labelsHidden()
                
                Text("desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hrs",
                value: $sleepAmount,
                        in: 4...12,
                        step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                
            }
        }
        
    } // end body View
    
} // end contentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
