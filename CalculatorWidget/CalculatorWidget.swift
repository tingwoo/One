//
//  CalculatorWidget.swift
//  CalculatorWidget
//
//  Created by Tingwu on 2023/12/28.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

class TestClass {
    static var i: Int = 0
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct AddOne: AppIntent {

    static var title: LocalizedStringResource = "Emoji Ranger SuperCharger"
    static var description = IntentDescription("All heroes get instant 100% health.")

    func perform() async throws -> some IntentResult {
        TestClass.i += 1
        return .result()
    }
}

struct TmpKeys: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .font(.system(size: 23))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct CalculatorWidgetEntryView : View {
    var entry: Provider.Entry

    var gridSpacing: CGFloat = 7
    var keyHeight: CGFloat = 40

    @State var number: Int = 0

    var body: some View {
        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Emoji:")
//            Text(entry.emoji)
            Grid(horizontalSpacing: gridSpacing, verticalSpacing: gridSpacing) {
                GridRow {
                    ZStack {
                        // Inner shadow background
                        VStack {
                            HStack { Spacer() }
                            Spacer()
                        }
                        .background(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                            .fill(
                                Color("AccentInputField")
                                .shadow(.inner(color: Color(white: 0, opacity: 0.2), radius: 4))
                            )
                        )
                    }
                    .gridCellColumns(5)
                }


                GridRow {
                    Text("7").modifier(TmpKeys(color: Color("AccentKeys1")))
                    Text("8").modifier(TmpKeys(color: Color("AccentKeys1")))
                    Text("9").modifier(TmpKeys(color: Color("AccentKeys1")))
                    Text("/").modifier(TmpKeys(color: Color("AccentKeys1")))
                    Text("x").modifier(TmpKeys(color: Color("AccentKeys2")))
                }
                .frame(height: keyHeight)

                GridRow {
                    Grid(horizontalSpacing: gridSpacing, verticalSpacing: gridSpacing) {
                        GridRow {
                            Text("4").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("5").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("6").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("*").modifier(TmpKeys(color: Color("AccentKeys1")))
                        }
                        .frame(height: keyHeight)

                        GridRow {
                            Text("1").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("2").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("3").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("-").modifier(TmpKeys(color: Color("AccentKeys1")))
                        }
                        .frame(height: keyHeight)
                    }
                    .gridCellColumns(4)

                    Text("<")
                        .modifier(TmpKeys(color: Color("AccentKeys2")))
                        .frame(height: keyHeight * 2 + gridSpacing)
                }

                GridRow {
                    Grid(horizontalSpacing: gridSpacing, verticalSpacing: gridSpacing) {
                        GridRow {
                            Text("0").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text(".").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("%").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("+").modifier(TmpKeys(color: Color("AccentKeys1")))
                        }
                        .frame(height: keyHeight)

                        GridRow {
                            Text("(").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text(")").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text("<").modifier(TmpKeys(color: Color("AccentKeys1")))
                            Text(">").modifier(TmpKeys(color: Color("AccentKeys1")))
                        }
                        .frame(height: keyHeight)
                    }
                    .gridCellColumns(4)
//                    Button(intent: AddOne(), label: {Text("=")})
                    Text("=")
                        .modifier(TmpKeys(color: .yellow))
                        .frame(height: keyHeight * 2 + gridSpacing)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(for: .widget) {
                Color("AccentKeysBackground")
            }
//            .background(.red)
            // A way to copy results?
        }
    }
}

struct CalculatorWidget: Widget {
    let kind: String = "CalculatorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
//                CalculatorWidgetEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                CalculatorWidgetEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }

//            if #available(iOS 17.0, *) {
                CalculatorWidgetEntryView(entry: entry)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(.white)
//            } else {
//                CalculatorWidgetEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    CalculatorWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
