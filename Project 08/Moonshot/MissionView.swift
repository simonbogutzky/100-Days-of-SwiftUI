//
//  SwiftUIView.swift
//  Moonshot
//
//  Created by Simon Bogutzky on 28.10.20.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let missions: [Mission]
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader {
            fullView in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { geo in
                        Image(self.mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: (fullView.size.width * 0.7) * ((fullView.frame(in: .global).midY - (fullView.frame(in: .global).midY - geo.frame(in: .global).midY)) / fullView.frame(in: .global).midY) * 2)
                            .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.bottom] })
                                                .position(x: geo.size.width / 2, y: geo.size.height / 2 )
                            .padding(.top)
                            .onTapGesture {
                                print(fullView.frame(in: .global).midY)
                                print((fullView.frame(in: .global).midY - (fullView.frame(in: .global).midY - geo.frame(in: .global).midY)) / fullView.frame(in: .global).midY)
                            }
                        
                    }
                    
                    VStack {
                        Text("Launch date").font(.headline)
                        Text(mission.formattedLaunchDate)
                    }
                    .padding()
                    
                    VStack {
                        Text("Description").font(.headline)
                        Text(self.mission.description)
                        
                    }
                    .padding()
                    
                    ForEach(self.astronauts, id: \.role) {
                        crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut, missions: self.missions)) {
                        HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))

                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }.navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, missions: [Mission], astronauts: [Astronaut]) {
        self.mission = mission
        self.missions = missions
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], missions: missions, astronauts: astronauts)
    }
}
