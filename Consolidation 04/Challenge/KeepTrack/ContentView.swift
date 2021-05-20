//
//  ContentView.swift
//  KeepTrack
//
//  Created by Simon Bogutzky on 03.11.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activityRepository = ActivityRepository()
    @State private var showingAddActivity = false
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(activityRepository.activities, id: \.id) {
                    NavigationLink($0.title, destination: ActivityDetailView(activity: $0, activityRepository: activityRepository))
                    
                }
                .onDelete(perform: removeActivities)
            }
            .navigationBarTitle("KeepTrack")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.showingAddActivity = true
                }) {
                    Image(systemName: "plus")
                }
            )
        }.sheet(isPresented: $showingAddActivity) {
            AddActivityView(activityRepository: activityRepository)
        }
    }
    
    func removeActivities(at offsets: IndexSet) {
        self.activityRepository.activities.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
