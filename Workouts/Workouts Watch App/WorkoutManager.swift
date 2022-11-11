//
//  WorkoutManager.swift
//  Workouts Watch App
//
//  Created by kimhyungyu on 2022/11/09.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    /// to track selected workout.
    var selectedWorkout: HKWorkoutActivityType? {
        // whenever selsectedWorkout changes, call startWorkout.
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    func startWorkout(workoutType: HKWorkoutActivityType) {
        // create workout configuration with workoutType.
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor

        do {
            // create the workout session using the healthStore and configuration.
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }
        
        // An HKLiveWorkoutDataSource automatically provides live data from an active workout session.
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )

        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }
    
    /// Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }
    
    // MARK: - State Control

    // The workout session state.
    // Create a publisher of this type.
    @Published var running = false

    func pause() {
        session?.pause()
    }

    func resume() {
        session?.resume()
    }

    func togglePause() {
        if running == true {
            pause()
        } else {
            resume()
        }
    }

    func endWorkout() {
        session?.end()
    }
}
