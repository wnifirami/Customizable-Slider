import SwiftUI

struct ConfigurationSheet: View {
    @Binding var activePreset: ConfigurationPreset
    @Binding var showsDragIndicator: Bool
    @Binding var showsOnlyBoundaryLabels: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Toggle("Drag Indicator", isOn: $showsDragIndicator)
                    Toggle("Boundary Labels Only", isOn: $showsOnlyBoundaryLabels)
                }

                Section("Theme") {
                    ForEach(ConfigurationPreset.allCases, id: \.self) { preset in
                        let config = preset.sliderConfiguration
                        Button {
                            activePreset = preset
                        } label: {
                            HStack {
                                Circle()
                                    .fill(config.colors.fill)
                                    .frame(width: 14, height: 14)
                                Text(preset.rawValue)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if activePreset == preset {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(config.colors.fill)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
