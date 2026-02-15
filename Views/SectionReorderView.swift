import SwiftUI

struct SectionReorderView: View {
    @Binding var sectionOrder: [String]?
    @Environment(\.dismiss) var dismiss
    
    // Default order referencing the enum's static property
    let defaultOrder = ResumeSection.defaultOrder
    
    // State to hold the current order locally
    @State private var currentOrder: [String] = []
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(currentOrder, id: \.self) { sectionId in
                        HStack {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.gray)
                            Text(sectionId)
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                        }
                    }
                    .onMove(perform: move)
                } header: {
                    Text("Drag to Reorder Sections")
                } footer: {
                    Text("This order will be reflected in your resume preview and PDF export.")
                }
                
                Section {
                    Button("Reset to Default") {
                        currentOrder = defaultOrder
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Reorder Sections")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        sectionOrder = currentOrder
                        dismiss()
                    }
                }
            }
            .onAppear {
                // Initialize with existing order or default
                if let order = sectionOrder, !order.isEmpty {
                    // Ensure all current cases are present (migration safety)
                    var mergedOrder = order
                    for section in defaultOrder {
                        if !mergedOrder.contains(section) {
                            mergedOrder.append(section)
                        }
                    }
                    // Remove any obsolete sections if necessary (optional)
                    currentOrder = mergedOrder
                } else {
                    currentOrder = defaultOrder
                }
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        currentOrder.move(fromOffsets: source, toOffset: destination)
    }
}
