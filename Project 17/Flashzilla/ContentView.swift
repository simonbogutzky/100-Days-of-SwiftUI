//
//  ContentView.swift
//  Flashzilla
//
//  Created by Simon Bogutzky on 15.12.20.
//

import SwiftUI



struct ContentView: View {
    
    var settings = SettingsObject()
    
    static var sheetViewConfiguration: SheetViewConfiguration = .editCards
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @State private var cards = [Card]()
    
    @State private var showingSheetView = false
    private var sheetViewConfiguration: SheetViewConfiguration = .editCards
    
    @State private var timeRemaining = 100
    
    @State private var showTimeRunsOut = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var isActive = true
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
                VStack {
                    Text("Time: \(timeRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.black)
                                .opacity(0.75)
                        )
                    
                    ZStack {
                        ForEach(0..<cards.count, id: \.self) { index in
                            CardView(card: self.cards[index]) { isCorrect in
                                withAnimation {
                                    if (settings.putWrongCardsBack && !isCorrect) {
                                        
                                    } else {
                                        self.removeCard(at: self.cards.count - 1)
                                    }
                                }
                            }
                            .stacked(at: index, in: self.cards.count)
                            .allowsHitTesting(index == self.cards.count - 1)
                            .accessibility(hidden: index < self.cards.count - 1)
                        }
                    }.allowsHitTesting(timeRemaining > 0)
                    
                    if cards.isEmpty {
                        Button("Start Again", action: resetCards)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }
            VStack {
                HStack {
                    Button(action: {
                        self.isActive = false
                        ContentView.sheetViewConfiguration = .settingsView
                        self.showingSheetView = true
                    }) {
                        Image(systemName: "gear")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()

                    Button(action: {
                        self.isActive = false
                        ContentView.sheetViewConfiguration = .editCards
                        self.showingSheetView = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            withAnimation {
                                if (settings.putWrongCardsBack) {
                                    self.cards.shuffle()
                                } else {
                                    self.removeCard(at: self.cards.count - 1)
                                }
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()

                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                        
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .environmentObject(settings)
        .sheet(isPresented: $showingSheetView, onDismiss: resetCards) {
            SheetView(configuration: ContentView.sheetViewConfiguration, settings: settings)
        }
        .alert(isPresented: $showTimeRunsOut) {
            Alert(title: Text("Time runs out"), message: nil, dismissButton: .default(Text("Restart")) {
                self.resetCards()
            })
        }
        .onAppear(perform: resetCards)
        .onReceive(timer) { time in
            guard self.isActive else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            
            if (self.timeRemaining == 0) {
                self.isActive = false
                self.feedback.notificationOccurred(.error)
                showTimeRunsOut = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.isActive = true
        }
        
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}
