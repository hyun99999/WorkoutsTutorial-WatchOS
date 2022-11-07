//
//  SessionPagingView.swift
//  Workouts Watch App
//
//  Created by kimhyungyu on 2022/11/04.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
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
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
