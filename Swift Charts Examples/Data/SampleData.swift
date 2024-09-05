import SwiftData
import SwiftUI
import SwiftCSV

@MainActor
class DataController {
    static let populateContainer: ModelContainer = {
        do {
            //let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: ECGItem.self) // configurations: config)
            
            // Make sure the persistent store is empty. If it's not, return the non-empty container.
            var itemFetchDescriptor = FetchDescriptor<ECGItem>()
            itemFetchDescriptor.fetchLimit = 1
            
            guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
            
            do {

                if let fileURL = Bundle.main.url(forResource: "neurokit_simulation_ecg_header", withExtension: "csv") {
                    // we found the file in our bundle!
                    // From a file (propagating error during file loading)
                    let csvFile: CSV = try CSV<Named>(url: fileURL)
                    
                    for header in csvFile.header{
                        print(header)
                        let doubles = csvFile.columns?[header]?.compactMap(Double.init)
                        let item = ECGItem(dataPoints: doubles!, title: header)
                        container.mainContext.insert(item)
                    }
                }
            } catch {
                // Catch errors from trying to load files
                print("File does not exist in App Sandbox!")
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
