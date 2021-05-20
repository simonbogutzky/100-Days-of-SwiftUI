//
//  MeetingPictureView.swift
//  MeetingPictures
//
//  Created by Simon Bogutzky on 05.12.20.
//

import SwiftUI

struct MeetingPictureView: View {
    var meetingPicture: MeetingPicture

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(uiImage: UIImage(data: meetingPicture.imageData!)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width)
                MapView(centerCoordinate: meetingPicture.location)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle(Text(meetingPicture.wrappedName), displayMode: .inline)
    }
}

struct MeetingPictureView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingPictureView(meetingPicture: MeetingPicture())
    }
}
