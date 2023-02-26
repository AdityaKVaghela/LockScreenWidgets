//
//  ContentView.swift
//  Lockscreen widgets
//
//  Created by MacBook Pro on 24/09/22.
//

import SwiftUI
import WebKit
import WidgetKit
import BackgroundTasks

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    let images = ["heart.fill","heart","heart.text.square","heart.text.square.fill"]
    @State var activeImageIndex = 1 // Index of the currently displayed image
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "myapprefresh")
        request.earliestBeginDate = .now.addingTimeInterval(60)
        try? BGTaskScheduler.shared.submit(request)
    }
    let imageSwitchTimer = Timer.publish(every : 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack {
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .onChange(of: scenePhase) { newPhase in
                    scheduleAppRefresh()
                    WidgetCenter.shared.reloadAllTimelines()
                }
            Image(systemName: images[activeImageIndex])
                .onReceive(imageSwitchTimer) { _ in
                    // Go to the next image. If this is the last image, go
                    // back to the image #0
                    self.activeImageIndex = (self.activeImageIndex + 1) % self.images.count
                    Image(systemName: images[activeImageIndex])
                }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
        
    }
}
