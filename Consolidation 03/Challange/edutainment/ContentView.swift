//
//  ContentView.swift
//  edutainment
//
//  Created by Simon Bogutzky on 21.10.20.
//

import SwiftUI

class GameObject: ObservableObject {
    @Published var isActive = false
    @Published var difficultyRange = 5
    @Published var qas = [(String, String)]()
    var amountLabel = ["5", "10", "20", "All"]
    @Published var selectedAmount = 0
    @Published var score = 0
    @Published var finished = false
    var currentQuestion: String {
        return qas[currentQuestionIndex].0
    }
    @Published var currentQuestionIndex = 0
    
    func generateQas() {
        currentQuestionIndex = 0
        score = 0
        finished = false
        qas.removeAll()
        
        var allQas = [(String, String)]()
        
        for i in 0...difficultyRange {
            for j in 0...difficultyRange {
                allQas.append(("\(i) x \(j)", "\(i * j)"))
            }
        }
        
        var amount = Int(amountLabel[selectedAmount]) ?? allQas.count
        amount = allQas.count < amount ? allQas.count : amount
        
        allQas = allQas.shuffled()
        
        for k in 0..<amount {
            qas.append(allQas[k])
        }
        
        for l in 0..<amount {
            print("\(qas[l].0) = \(qas[l].1)")
        }
    }
    
    func answerCurrentQuestion(answer: String) {
        if answer == qas[currentQuestionIndex].1 {
            score += 1
        }
        
        if (currentQuestionIndex == qas.count - 1) {
            finished = true
            return
        }
        
        if (currentQuestionIndex < qas.count) {
            currentQuestionIndex += 1
        }
    }
}

struct SettingsView: View {
    @ObservedObject var game: GameObject

    var body: some View {
        VStack {
            Text("Setting").font(.title).padding()
            HStack {
                Stepper("Difficulty range", value: $game.difficultyRange, in: 0...12)
                Text("\(game.difficultyRange)").font(.system(.body, design: .monospaced)).frame(width: 40)
                
            }
            Text("Please choose amount").font(.headline)
            Picker(selection: $game.selectedAmount, label: Text("")) {
                ForEach(0 ..< game.amountLabel.count) {
                    Text(game.amountLabel[$0])
                        }
            }.labelsHidden()
            Button(action: {
                game.isActive.toggle()
                game.generateQas()
            }, label: {
                Text("Start")
            })
            
        }.padding()
    }
}

struct GameView: View {
    @ObservedObject var game: GameObject
    @State var answer: String = ""
    
    var body: some View {
        VStack {
            Text("Multiplication \(game.difficultyRange) x \(game.difficultyRange)").font(.title).padding()
            HStack {
                Text("\(game.currentQuestion) = ").font(.headline)
                TextField("", text: $answer).disabled(game.finished)
                Button(action: {
                    game.answerCurrentQuestion(answer: answer)
                    answer = ""
                }, label: {
                    Text("OK")
                }).disabled(game.finished)
            }.padding()
            
            Text("Score: \(game.score)").padding()
            
            Button(action: {
                game.isActive.toggle()
            }, label: {
                Text("Re-start")
            })
            
        }.padding()
    }
}

struct ContentView: View {
    @ObservedObject private var game = GameObject()
    
    var body: some View {
        Group {
            if game.isActive {
                GameView(game: game)
            } else {
                SettingsView(game: game)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
