//
//  WorkoutsApp.swift
//  Workouts Watch App
//
//  Created by kimhyungyu on 2022/11/03.
//

import SwiftUI

@main
struct Workouts_Watch_AppApp: App {
    @StateObject var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .environmentObject(workoutManager)
        }
    }
}
