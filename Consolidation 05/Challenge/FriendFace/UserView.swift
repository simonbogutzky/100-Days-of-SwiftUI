//
//  UserView.swift
//  FriendFace
//
//  Created by Simon Bogutzky on 28.10.20.
//

import SwiftUI

struct UserView: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest: FetchRequest<User>
    
    var users: FetchedResults<User> { fetchRequest.wrappedValue }
    
    let userId: UUID
    var user: User {
        return users[0]
    }
 
    var body: some View {
        VStack {
            Text(user.wrappedEmail)
            Text(user.wrappedAddress)
            Text(user.wrappedCompany)
        }
        .padding()
        
        List {
            ForEach(self.user.friendArray, id: \.self) { friend in
                NavigationLink(destination: UserView(userId: friend.id!)) {
                    Text(friend.wrappedName)
                }
            }
        }
        .navigationBarTitle(Text(user.wrappedName), displayMode: .inline)
    }
    
    init(userId: UUID) {
        self.userId = userId
        fetchRequest = FetchRequest<User>(entity: User.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id == %@", userId as CVarArg))
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static let users: [UserVO] = Bundle.main.decode("friendface.json")
    
    static var previews: some View {
        UserView(userId: users[0].id)
    }
}
