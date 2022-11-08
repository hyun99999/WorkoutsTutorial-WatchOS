//
//  ActivityRingsView.swift
//  Workouts Watch App
//
//  Created by kimhyungyu on 2022/11/08.
//

import HealthKit
import SwiftUI

struct ActivityRingsView: WKInterfaceObjectRepresentable {
    let healthStore: HKHealthStore

    // `makeWKInterfaceObject(context:)` and `updateWKInterfaceObject(_:context:)` method is required to conform to WKInterfaceObjectRepresentable protocol.
    
    /// Creates a WatchKit interface object and configures its initial state.
    func makeWKInterfaceObject(context: Context) -> some WKInterfaceObject {
        let activityRingsObject = WKInterfaceActivityRing()

        let calendar = Calendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day], from: Date())
        components.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: components)

        let query = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
            DispatchQueue.main.async {
                activityRingsObject.setActivitySummary(summaries?.first, animated: true)
            }
        }

        healthStore.execute(query)

        return activityRingsObject
    }

    /// Updates the presented WastchKit interface object (and its coordinator) to the latest configuration.
    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceObjectType, context: Context) {

    }
}
