//
//  SessionPagingView.swift
//  Workouts Watch App
//
//  Created by kimhyungyu on 2022/11/04.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    // default is metrics. the metrics view is displayed.
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, metrics, nowPlaying
    }
    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            // SwiftUI view provided by WatchKit.
            NowPlayingView().tag(Tab.nowPlaying)
        }
        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        // We don't want go back to the StartView while they are in a workout.
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying)
        // We shouldn't need to swipe to the MatrcisView when they pauses or resumes their workout.
        .onChange(of: workoutManager.running) { _ in
            displayMetricsView()
        }
    }
    
    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
            .environmentObject(WorkoutManager())
    }
}
