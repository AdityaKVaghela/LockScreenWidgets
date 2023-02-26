//
//  Lockscreen_Widgets.swift
//  Lockscreen Widgets
//
//  Created by MacBook Pro on 24/09/22.
//

import WidgetKit
import SwiftUI
import UserNotifications

var  currentEvent = 0
let images = ["1","2","3","4","5","6","7","8","9","10",
              "1","2","3","4","5","6","7","8","9","10",
              "1","2","3","4","5","6","7","8","9","10",
              "1","2","3","4","5","6","7","8","9","10",
              "1","2","3","4","5","6","7","8","9","10",
              "1","2","3","4","5","6","7","8","9","10"]
struct Provider: TimelineProvider {
  
   
    func placeholder(in context: Context) -> SimpleEntry {
//        WidgetCenter.shared.reloadAllTimelines()
        return SimpleEntry(date: Date(), image: Image("1"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),image: Image(images[currentEvent]))
        WidgetCenter.shared.reloadAllTimelines()
        completion(entry)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("BEGIN ANIMATION")

        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for i in 0 ..< images.count {
            let entryDate = Calendar.current.date(byAdding: .second, value: i, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,image: Image(images[i]))
            entries.append(entry)
            }
        currentEvent = 0
       
        let reloadDate = Calendar.current.date(byAdding: .minute,
                                               value: 1,
                                                    to: currentDate)!
        print("Current Date",currentDate)
        print("Reload Date",reloadDate)

//        let timeline = Timeline(entries: entries, policy: .atEnd)

        let timeline = Timeline(entries: entries, policy: .after(reloadDate))
     
        print("timeline",timeline)

        completion(timeline)
      
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: Image
}

struct Lockscreen_WidgetsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily{
        case .accessoryCircular:
            
                        entry.image
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 50.0, height: 50.0)
            
        case .accessoryRectangular:
                        entry.image
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 50.0, height: 50.0)
            
        case  .accessoryInline:
            Text(entry.date, format: .dateTime.second())
        default:
            entry.image
        }
    }
}

@main
struct Lockscreen_Widgets: Widget {
    let kind: String = "Lockscreen_Widgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
           return Lockscreen_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryInline,.accessoryCircular,.accessoryRectangular])
    }
}

struct Lockscreen_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        Lockscreen_WidgetsEntryView(entry: SimpleEntry(date: Date(),image: Image(systemName: "heart")))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
        
        Lockscreen_WidgetsEntryView(entry: SimpleEntry(date: Date(),image: Image(systemName: "heart")))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circuler")
        
        Lockscreen_WidgetsEntryView(entry: SimpleEntry(date: Date(),image: Image(systemName: "heart")))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
    }
}


