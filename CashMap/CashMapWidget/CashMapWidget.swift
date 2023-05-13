//
//  CashMapWidget.swift
//  CashMapWidget
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import WidgetKit
import SwiftUI



struct Provider: TimelineProvider {
    var placeHolderSums : [Double] = [34.22,78.00,0.00,11.99,45.21,60.78,55.22,11.24]
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), totalSpent: placeHolderSums)
        
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), totalSpent: placeHolderSums)
        completion(entry)
        // testing
        
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []

        let transactionData = getTransactionData()
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            // decode transactions from the user defaults
            // was set like so
            //  UserDefaults(suiteName:
            //"group.edu.indiana.cs.c323-")!.set(transactionData, forKey: "purchases")
       
        let entry = SimpleEntry(date: Date(),totalSpent: transactionData)
       
        entries.append(entry)
            
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalSpent : [Double]
}

struct CashMapWidgetEntryView : View {
    var entry: Provider.Entry

    // try to implement the transacin model laodt transations here
    
    var body: some View {
        HStack(alignment: .top, spacing: 42 ){
            VStack(alignment: .center, spacing: 5){
                VStack(alignment: .center, spacing: 1){
                    Text("🛒")
                    Text("\(entry.totalSpent[0], specifier: "%.2f")").font(.system(size: 12)).foregroundColor(Color(uiColor: UIColor.darkGray))
                }
                VStack(alignment: .center, spacing: 1){
                    Text("🍺")
                    Text("\(entry.totalSpent[1], specifier: "%.2f")").font(.system(size: 12)).foregroundColor(Color(uiColor: UIColor.darkGray))
                }
                VStack(alignment: .center, spacing: 1){
                    Text("☕️")
                    Text("\(entry.totalSpent[2], specifier: "%.2f")").font(.system(size: 12)).foregroundColor(Color(uiColor: UIColor.darkGray))
                }
                VStack(alignment: .center, spacing: 1){
                    Text("👕")
                    Text("\(entry.totalSpent[3], specifier: "%.2f")").font(.system(size: 12)).foregroundColor(Color(uiColor: UIColor.darkGray))
                }
            }
            VStack(alignment: .center, spacing: 5){
                VStack(alignment: .center, spacing: 1){
                    Text("🥪")
                    Text("\(entry.totalSpent[4], specifier: "%.2f")").font(.system(size: 12)).foregroundColor(Color(uiColor: UIColor.darkGray))
                }
                VStack(alignment: .center, spacing: 1){
                    Text("🚕")
                    Text("\(entry.totalSpent[5], specifier: "%.2f")").font(.system(size: 12)).foregroundColor(Color(uiColor: UIColor.darkGray))
                }
                VStack(alignment: .center, spacing: 1){
                    Text("🎬")
                    Text("\(entry.totalSpent[6], specifier: "%.2f")").font(.system(size: 12)).foregroundColor(Color(uiColor: UIColor.darkGray))
                }
                VStack(alignment: .center, spacing: 1){
                    Text("🏠")
                    Text("\(entry.totalSpent[7], specifier: "%.2f")").font(.system(size: 12)).foregroundColor(Color(uiColor: UIColor.darkGray))
                }
            }
           
        }
        
    }
}

struct CashMapWidget: Widget {
    let kind: String = "CashMapWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CashMapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Total Spending")
        .description("Be aware of your total spending at a glance.")
    }
}

struct CashMapWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        CashMapWidgetEntryView(entry: SimpleEntry(date: Date(),totalSpent: getTransactionData()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
    
    

}

// helper funtion to get data for the timeline
func getTransactionData() -> [Double]{
    var priceSums = [Double](repeating: 0.00, count: 8)
    
    let encodedData  = UserDefaults(suiteName: "group.edu.indiana.cs.c323-")!.object(forKey: "purchases") as? Data
    if let transactionsEncoded = encodedData {
        let tractionsDecoded = try? JSONDecoder().decode(Transactions.self, from: transactionsEncoded)
        if let transactions = tractionsDecoded{
            // You successfully retrieved your transaction object!
            var totalMoney : Double = 0.00
       
            // iterate over all transactions, and give the total as arg to SimpleEntry
            for t in transactions.transactions{
                // catagories are...
                // "Food", "Entertainment", "Rides", "Cloths","House", "Alcohol", "Coffee", "Groceries"
                
                // debug here
                print("catagory is: " + t.category)
                
                switch t.category{
                    
                case "Groceries":
                    priceSums[0] += Double(t.amount)
                case "Alcohol":
                    priceSums[1] += Double(t.amount)
                case "Coffee":
                    priceSums[2] += Double(t.amount)
                case "Cloths":
                    priceSums[3] += Double(t.amount)
                case "Food":
                    priceSums[4] += Double(t.amount)
                case "Rides":
                    priceSums[5] += Double(t.amount)
                case "Entertainment":
                    priceSums[6] += Double(t.amount)
                case "House":
                    priceSums[7] += Double(t.amount)
                    
                default:
                    totalMoney += Double(t.amount)
                }
            }
        }
    }
    
    return priceSums
}
