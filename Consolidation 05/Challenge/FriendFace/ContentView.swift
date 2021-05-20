//
//  ContentView.swift
//  FriedFace
//
//  Created by Simon Bogutzky on 27.10.20.
//

import SwiftUI

struct ContentView: View {
    @State private var userVOs: [UserVO] = [UserVO]() {
        didSet {
            for userVO in userVOs {
                let user = User(context: self.viewContext)
                user.id = userVO.id
                user.name = userVO.name
                user.email = userVO.email
                user.address = userVO.address
                user.company = userVO.company
                for friendVO in userVO.friends {
                    let friend = Friend(context: self.viewContext)
                    friend.id = friendVO.id
                    friend.name = friendVO.name
                    user.addToFriends(friend)
                }
            }
            try? self.viewContext.save()
        }
    }
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var users: FetchedResults<User>
    
    var body: some View {
        NavigationView
        {
            List {
                ForEach(users, id: \.self) { user in
                    NavigationLink(destination: UserView(userId: user.id!)) {
                        Text(user.wrappedName)
                    }
                }
            }
            .navigationBarTitle("FriendFace")
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        if users.count == 0 {
            print("load")
        
            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    
                    if let decodedResponse = try? decoder.decode([UserVO].self, from: data) {
                        // we have good data – go back to the main thread
                        DispatchQueue.main.async {
                            // update our UI
                            self.userVOs = decodedResponse
                        }

                        // everything is good, so we can exit
                        return
                    }
                }

                // if we're still here it means there was a problem
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }.resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
