//
//  AddActivityView.swift
//  KeepTrack
//
//  Created by Simon Bogutzky on 03.11.20.
//

import SwiftUI

struct AddActivityView: View {
    @State private var title = ""
    @State private var description = ""
    @ObservedObject var activityRepository: ActivityRepository
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Text("Activity").padding()
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationBarTitle("New activity")
            .navigationBarItems(trailing: Button("Add") {
                if title == "" && description == "" { return }
                activityRepository.activities.append(Activity(title: title, description: description))
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(activityRepository: ActivityRepository())
    }
}
