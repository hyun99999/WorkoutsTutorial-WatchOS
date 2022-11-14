//
//  MetricsView.swift
//  Workouts Watch App
//
//  Created by kimhyungyu on 2022/11/04.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(alignment: .leading) {
            ElapsedTimeView(
                elapsedTime: workoutManager.builder?.elapsedTime ?? 0,
                showSubseconds: true
            ).foregroundColor(.yellow)
            Text(
                Measurement(
                    value: workoutManager.activeEnergy,
                    unit: UnitEnergy.kilocalories
                ).formatted(
                    .measurement(
                        width: .abbreviated,
                        usage: .workout,
                        numberFormatStyle: .number)
                )
            )
            Text(
                workoutManager.heartRate
                    .formatted(
                        .number.precision(.fractionLength(0))
                    )
                + " bpm"
            )
            Text(
                Measurement(
                    value: workoutManager.distance,
                    unit: UnitLength.meters
                ).formatted(
                    .measurement(
                        width: .abbreviated,
                        usage: .road
                    )
                )
            )
        }
        .font(.system(.title, design: .rounded)
            .monospacedDigit()
            .lowercaseSmallCaps()
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(edges: .bottom)
        .scenePadding()
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
            .environmentObject(WorkoutManager())
    }
}
