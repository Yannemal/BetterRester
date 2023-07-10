//
//  ContentView.swift
//  BetterRester
//  DAY26 / 100DaysOfSwiftUI by @TwoStraws PaulHudson
//  Student: yannemal on 09/07/2023.
//
import CoreML
import SwiftUI

struct ContentView: View {
    // MARK: - DATA
    @State private var wakeUp  = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    // Alert message
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    // computed Property
    static var defaultWakeTime: Date {
        var components = DateComponents()
        // first we set up our own variable as DateComponents Struct
        components.hour = 7
        components.minute = 0
        // then we customise the parts we want
        return Calendar.current.date(from: components) ?? Date.now
        //computed props always need a return
    }
    // this computed prop needs to be * static * so its for the entire struct and any instance of the struct
    // (and can be assigned to itself)
    
    var body: some View {
        // MARK: - VIEW
        
        NavigationView {
         
            Form {
                
                Section {
                    Text("When do you want to wake up ?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time",
                               selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                    .labelsHidden()
                }
                
                Section{
                    Text("desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hrs",
                            value: $sleepAmount,
                            in: 4...12,
                            step: 0.25)
                }
                
                Section{
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper(coffeeAmount == 1 ? "1 mug" : "\(coffeeAmount) cups",
                            value: $coffeeAmount,
                            in: 1...20)
                }
            }
            //surprised to see this within NavigationView { here }
            //but I guess if its outside NavigationView { .. } here
            // then each page within Nav View Controller has the same title and same button
            // now only this page has BetterRest + toolbar > Button 'Calculate'
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate Sleep", action: calculateBedTime)
            }
            // within Nav View its alertMessage customised
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("👍🏻") { }
            } message: {
                Text(alertMessage)
            }
            
        }
        
    } // end body View
    
    // MARK: - METHODS
    func calculateBedTime() {
        //code to work w CoreML
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            //we need to feed in our data as doubles
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60 * 60
            //we need to get out our prediction
            
            let prediction = try model.prediction(wake: Double(hour + minute),
                                        estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            // the outcome needs to be subtracted from the wakeUp time to give the time to go to bed
            
            let sleepTime = wakeUp - prediction.actualSleep
            // now show this date to the user using the Alert but only hrs and minute not the actual date we got
            alertTitle = "Your ideal bedtime is.."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            // oops
            alertTitle = "Error"
            alertMessage = "There was a problem calculating your bedTime, try again later."
            //showingAlert = true
            
        }
        // wether caught a bug or correct then show message
        showingAlert = true
    }
    
} // end contentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
