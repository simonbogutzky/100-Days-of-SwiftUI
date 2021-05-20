//
//  AstronautView.swift
//  Moonshot
//
//  Created by Simon Bogutzky on 28.10.20.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                        Text(self.astronaut.description)
                            .padding().layoutPriority(1)
                    
                    Text("Missions").font(.headline)
                    
                    ForEach(self.missions, id: \.id) {
                        mission in
                        
                        VStack
                        {
                            Text("Apollo \(mission.id)")
                            Text(mission.formattedLaunchDate)
                                .foregroundColor(.secondary)
                        }.padding()
                    }
                }
            }
            .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
        }
    }
    
    init(astronaut: Astronaut, missions: [Mission]) {
        self.astronaut = astronaut
        var matches = [Mission]()
        
        for mission in missions {
            for member in mission.crew {
                if astronaut.id == member.name {
                    matches.append(mission)
                }
            }
        }
        
        self.missions = matches
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0], missions: missions)
    }
}
