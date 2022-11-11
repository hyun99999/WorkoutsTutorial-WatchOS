//
//  ControlsView.swift
//  Workouts Watch App
//
//  Created by kimhyungyu on 2022/11/05.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        HStack {
            VStack {
                Button {
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(Color.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button {
                } label: {
                    Image(systemName: "pause")
                }
                .tint(Color.yellow)
                .font(.title2)
                Text("Pause")
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
