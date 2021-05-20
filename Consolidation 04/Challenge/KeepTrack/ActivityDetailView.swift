//
//  ActivityDetailView.swift
//  KeepTrack
//
//  Created by Simon Bogutzky on 03.11.20.
//

import SwiftUI

struct ActivityDetailView: View {
    @State var activity: Activity
    @ObservedObject var activityRepository: ActivityRepository
    
    var body: some View {
        NavigationView {
            VStack {
                Text(activity.title)
                Text(activity.description)
                Text("Count: \(activity.completionCount)")
                Button("+") {
                    activity.completionCount += 1
                    if let index = activityRepository.activities.firstIndex(where: { $0.id == activity.id }) {
                    
                        self.activityRepository.activities[index].completionCount += 1
                        
                    }
                }
            }
        }.navigationBarTitle("Activity details")
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: Activity(title: "", description: ""), activityRepository: ActivityRepository())
    }
}
