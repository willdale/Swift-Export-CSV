//
//  ContentView.swift
//  Export CSV
//
//  Created by Will Dale on 19/11/2020.
//

import SwiftUI

struct ContentView: View {
    
    @State var isSharePresented : Bool = false
    
    let dataEntries : [DataModel] = Data().dataEntries
    
    var body: some View {
        Button(action: {
            isSharePresented.toggle()
        }, label: {
            Text("Test Sharing")
        })
        .padding()
        .sheet(isPresented: $isSharePresented, onDismiss: {
            isSharePresented = false
        }, content: {
            // Show SharingScreen with CSV attached
            ActivityViewController(itemsToShare: [createCSV("Test Export")])
                .edgesIgnoringSafeArea(.bottom)
        })
    }
    
    func createCSV(_ name: String) -> NSURL {
        let fileName = name
        let ext = ".csv"
        let saveName = "\(fileName)\(ext)"
        guard let path = try? FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: false).appendingPathComponent(saveName) as NSURL else { return NSURL() }
        
        /*
         ** Localized **
         
         var csv = NSLocalizedString("export-header", comment: "")
         
         ** Localizable.strings **
         "export-header" = "Date,Entry\n";
         
         let dateFormatter = DateFormatter()
         dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd-hh:mm")
         
         */
        
        var csv = "Date,Entry\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh:mm"
        
        for data in dataEntries {
            let entry = "\(dateFormatter.string(from: data.date)),\(data.entry)\n"
            csv.append(entry)
        }
        
        do {
            try csv.write(to: path as URL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error.localizedDescription)")
        }
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Test Data
struct DataModel {
    let id      : UUID
    let date    : Date
    let entry   : String
}

struct Data {
    let dataEntries : [DataModel] = [
        DataModel(id: UUID(), date: Date(), entry: "One"),
        DataModel(id: UUID(), date: Date(), entry: "Two"),
        DataModel(id: UUID(), date: Date(), entry: "Three"),
        DataModel(id: UUID(), date: Date(), entry: "Four"),
        DataModel(id: UUID(), date: Date(), entry: "Five"),
        DataModel(id: UUID(), date: Date(), entry: "Six"),
        DataModel(id: UUID(), date: Date(), entry: "Seven"),
        DataModel(id: UUID(), date: Date(), entry: "Eight")
    ]
}

// Export for Testing
struct ActivityViewController: UIViewControllerRepresentable {
    
    var itemsToShare            : [Any]
    var applicationActivities   : [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
    
    typealias UIViewControllerType = UIActivityViewController
}
