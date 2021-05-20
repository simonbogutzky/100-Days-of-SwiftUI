//
//  ProspectView.swift
//  HotProspects
//
//  Created by Simon Bogutzky on 12.12.20.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortFilterType {
        case name, mostRecent
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingSortingAlert = false
    let filter: FilterType
    @State private var sortFilter: SortFilterType = .name
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        var filterdProspects: [Prospect] = []
        switch filter {
        case .none:
            filterdProspects = prospects.people
        case .contacted:
            filterdProspects = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            filterdProspects = prospects.people.filter { !$0.isContacted }
        }
        
        switch sortFilter {
        case .mostRecent:
            filterdProspects = filterdProspects.sorted { $0.date < $1.date }
        case .name:
            filterdProspects = filterdProspects.sorted { $0.name < $1.name }
        }
        
        return filterdProspects
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) {
                    prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name).font(.headline)
                            Text(prospect.emailAddress).foregroundColor(.secondary)
                            
                        }
                        Spacer()
                        
                        prospect.isContacted ? Image(systemName: "envelope")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20) : Image(systemName: "envelope.badge")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ) {
                            self.prospects.toggle(prospect)
                        }
                        
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(leading: Button(action: {
                self.isShowingSortingAlert = true
            }) {
                Image(systemName: "arrow.up.arrow.down.square")
                Text("Sort")
            }, trailing: Button(action: {
                self.isShowingScanner = true
            }) {
                
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
            }
            .alert(isPresented: $isShowingSortingAlert) {
                Alert(title: Text("Sort"), message: Text("by"), primaryButton: .default(Text("Name"), action: {
                    sortFilter = .name
                }), secondaryButton: .default(Text("Most Recent"), action: {
                    sortFilter = .mostRecent
                }))
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            self.prospects.add(person)
        case .failure( _):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                    print(error);
                }
                print("delivered");
            })
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectView(filter: .none)
    }
}
