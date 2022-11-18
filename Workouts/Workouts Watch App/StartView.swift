//
//  ContentView.swift
//  Workouts Watch App
//
//  Created by kimhyungyu on 2022/11/03.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .walking]
    
    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(
                workoutType.name,
                destination: SessionPagingView(),
                tag: workoutType,
                selection: $workoutManager.selectedWorkout
            ).padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }
        .listStyle(.carousel)
        .navigationTitle("Workouts")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(WorkoutManager())
    }
}

extension HKWorkoutActivityType: Identifiable {
    // to display the list of workouts.
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .running:
            return "Run"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        default:
            return ""
        }
    }
}
