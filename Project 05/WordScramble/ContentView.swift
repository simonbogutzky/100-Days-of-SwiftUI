//
//  ContentView.swift
//  WordScramble
//
//  Created by Simon Bogutzky on 15.10.20.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = ["Ham", "Eggs", "Chicken", "Legs", "Ham", "Eggs", "Chicken", "Legs", "Ham", "Eggs", "Chicken", "Legs"]
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var allWords = [String]()
    @State private var score = 0
    
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var body: some View {
        NavigationView {
            GeometryReader { fullView in
                VStack {
                    TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                    
                    ScrollView(.vertical) {
                        ForEach(usedWords, id: \.self) { index in
                                        GeometryReader { geo in
                                            HStack {
                                                Image(systemName: "\(index.count).circle")
                                                Text(index)
                                            }
                                            .position(x: geo.frame(in: .local).width * 0.1, y: geo.frame(in: .local).midY)
                                            .frame(width: geo.frame(in: .local).width * 0.8, height: 32, alignment: .leading)
                                            .background(self.colors[index.count % 7])
                                            
                                        }
                                        .frame(height: 32)
                                        
                                        
                                    }
                                }
                    
                        //List(usedWords, id: \.self) {
                            //Image(systemName: "\($0.count).circle")
                            //Text($0)
                        //}
                    Text("Score: \(score)")
                    }
                    
                    
                }
            .navigationBarTitle(rootWord)
            .navigationBarItems(trailing:
                                    Button(action: restart) {
                Text("Restart")
            })
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        
        guard isNotStartWord(word: answer) else {
            wordError(title: "Word is the start word", message: "Be more original")
            return
        }
        
        guard isNotTooShort(word: answer) else {
            wordError(title: "Word is to short", message: "Must have at least 3 letters")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can not make it up, you know!")
            return
        }
        
        guard isRealWord(word: answer) else {
            wordError(title: "Word not possible", message: "That is not a real word")
            return
        }
        
        score += answer.count
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt")
    }
    
    func restart() {
        rootWord = allWords.randomElement() ?? "silkworm"
        newWord = ""
        usedWords.removeAll()
        score = 0
    }
    
    func isNotStartWord(word: String) -> Bool {
        word != rootWord
    }
    
    func isNotTooShort(word: String) -> Bool {
        word.count > 2
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isRealWord(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
