//
//  ContentView.swift
//  MeetingPictures
//
//  Created by Simon Bogutzky on 05.12.20.
//

import SwiftUI

struct ContentView: View {
    @State private var meetingPictures: [MeetingPicture] = [MeetingPicture]()
    @State private var showingSheet = false
    @State private var inputImage: UIImage?
    @State private var inputName: String?
    let locationFetcher = LocationFetcher()

    var body: some View {
        NavigationView {
            ZStack {
                List(meetingPictures.sorted()) { meetingPicture in
                    NavigationLink(destination: MeetingPictureView(meetingPicture: meetingPicture)) {
                        Image(uiImage: UIImage(data: meetingPicture.imageData!)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                        VStack(alignment: .leading) {
                            Text(meetingPicture.wrappedName)
                                .font(.headline)
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingSheet = true
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
            }.navigationBarTitle("Meeting Pictures")
            .onAppear(perform: {
                locationFetcher.start()
                loadData()
            })
            .sheet(isPresented: $showingSheet, onDismiss: {
                if inputImage != nil && inputName != nil {
                    if let jpegData = inputImage!.jpegData(compressionQuality: 0.8) {
                        var meetingPicture = MeetingPicture(name: inputName, imageData: jpegData)
                        if let location = self.locationFetcher.lastKnownLocation {
                            meetingPicture.latitude = location.latitude
                            meetingPicture.longitude = location.longitude
                        }
                        meetingPictures.append(meetingPicture)
                        saveData()
                    }
                    inputImage = nil
                    inputName = nil
                } else if inputImage != nil {
                    showingSheet = true
                }
            }, content: {
                if inputImage == nil {
                    ImagePicker(image: $inputImage)
                } else if inputName == nil {
                    AddDetailView(name: $inputName)
                }
            })
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedMeetingPictures")

        do {
            let data = try Data(contentsOf: filename)
            meetingPictures = try JSONDecoder().decode([MeetingPicture].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }

    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedMeetingPictures")
            let data = try JSONEncoder().encode(self.meetingPictures)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
