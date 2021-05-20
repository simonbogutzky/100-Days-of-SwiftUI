//
//  ContentView.swift
//  FliFlaFlu
//
//  Created by Simon Bogutzky on 13.10.20.
//

import SwiftUI

struct SymbolImage: View {
    var image: String

    var body: some View {
        Image(image)
            .renderingMode(.original)
            .padding()
            .background(Color.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.primary, lineWidth: 1))
            .shadow(color: .primary, radius: 2)
    }
}

struct ContentView: View {
    let symbols = ["rock", "paper", "scissors"]
    @State var symbolIndex = 0
    @State var shouldLose = false
    @State var score = 0
    @State var moves = 0
    @State var showingScore = false
    
    var appMove: String {
        get {
            return symbols[symbolIndex]
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Fli Fla Flu").foregroundColor(.primary).font(.largeTitle).fontWeight(.black)
                SymbolImage(image: appMove).padding()
                HStack {
                    if shouldLose {
                        SymbolImage(image: "should-lose")
                        SymbolImage(image: "should-win-enabled")
                    } else {
                        SymbolImage(image: "should-lose-enabled")
                        SymbolImage(image: "should-win")
                    }
                }.padding()
                HStack {
                    ForEach(0 ..< 3) { number in
                        Button(action: {
                            userMove(number: number)
                        }) {
                            SymbolImage(image: self.symbols[number])
                        }
                    }
                }.padding()
                Text("Current score: \(score)").foregroundColor(.primary).font(.largeTitle).fontWeight(.black)
                Spacer()
            }.onAppear {
                renewAppMove()
            }.alert(isPresented: $showingScore) {
                Alert(title: Text("Finished"), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                    resetGame()
                })
            }
        }
    }
    
    func userMove(number: Int) {
        if checkUserMove(selection: symbols[number]) {
            score += 1
        } else {
            if score > 0 {
                score -= 1
            }
        }
        moves += 1
        if moves == 10 {
            showingScore = true
        } else {
            renewAppMove()
        }
    }
    
    func checkUserMove(selection: String) -> Bool {
        if selection == appMove {
            return false
        }
        
        var correct = false
        switch appMove {
        case "rock":
            if selection == "paper" { correct = true }
        case "paper":
            if selection == "scissors" { correct = true }
        case "scissors":
            if selection == "rock" { correct = true }
        default:
            break
        }
        
        if shouldLose {
            correct = !correct
        }
        
        return correct
    }
    
    func renewAppMove() {
        symbolIndex = Int.random(in: 0...2)
        shouldLose = Bool.random()
    }
    
    func resetGame() {
        moves = 0
        score = 0
        renewAppMove()
        showingScore = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
