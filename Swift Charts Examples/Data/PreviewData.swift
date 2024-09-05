import SwiftData
import SwiftUI
import SwiftCSV

@MainActor
class PreviewController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: ECGItem.self, configurations: config)
            
            do {
                print("Went here !")
                let csvFile: CSV = try CSV<Named>(url: URL(fileURLWithPath: "/Users/f0gel/Documents/github_projects/Swift-Charts-Examples/Swift Charts Examples/neurokit_simulation_ecg_header.csv"))
                
                
                for header in csvFile.header{
                    print(header)
                    let doubles = csvFile.columns?[header]?.compactMap(Double.init)
                    let item = ECGItem(dataPoints: doubles!, title: header)
                    container.mainContext.insert(item)
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
