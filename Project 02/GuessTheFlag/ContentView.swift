//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Simon Bogutzky on 11.10.20.
//

import SwiftUI

struct FlagButton: View {
    var image: String
    var number = 0
    var isTheOne = false
    var action: () -> Void = {}
    @State var animationAmount = 0.0
    @State var strokeColor = Color.black

    var body: some View {
        Button(action: {
            action()
            if isTheOne {
                withAnimation(.easeInOut(duration: 2.0)) {
                    self.animationAmount += 360
                }
            } else {
                withAnimation(.easeInOut(duration: 2.0)) {
                    self.strokeColor = Color.red
                }
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                    strokeColor = Color.black
                }
            }
        }){
            Image(image)
                .renderingMode(.original)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(strokeColor, lineWidth: 1))
                .shadow(color: .black, radius: 2)
        }
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var opacities = [1.0, 1.0, 1.0]
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0..<3) { number in
                    FlagButton(image: self.countries[number], number: number, isTheOne: correctAnswer == number) {
                        self.flagTapped(number)
                    }.opacity(opacities[number])
                }
                Text("Current score: \(score)").foregroundColor(.white).font(.largeTitle).fontWeight(.black)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            
            withAnimation(.easeInOut(duration: 2.0)) {
                for i in 0...2 {
                    if i == number {
                        continue
                    }
                    opacities[i] = 0.75
                }
            }
        } else {
            scoreTitle = "Wrong, it was the flag of \(self.countries[number])"
            score -= 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            showingScore = true
        }
    }
    
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        for i in 0...2 {
            opacities[i] = 1.0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
