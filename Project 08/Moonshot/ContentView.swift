//
//  ContentView.swift
//  Moonshot
//
//  Created by Simon Bogutzky on 27.10.20.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var showMissionDate = false
    
    var body: some View {
        NavigationView
        {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, missions: self.missions, astronauts: self.astronauts)) {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.headline)
                            
                            showMissionDate ? Text(mission.formattedLaunchDate) : Text(mission.crewNames)
                        }
                    }
                }
                .navigationBarTitle("Moonshot")
                .navigationBarItems(leading: Button(showMissionDate ? "Name" : "Date") {
                showMissionDate.toggle()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
