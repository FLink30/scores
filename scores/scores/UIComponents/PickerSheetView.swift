//
//  PickerView.swift
//  scores
//
//  Created by Franziska Link on 09.12.23.
//


// Version 3 /////////////////////////

import SwiftUI

struct PickerSheetView<T: Hashable & CaseIterable & PickerData>: View where T.AllCases == [T] {

    @Binding private var selectedItem: T?
    @Environment(\.presentationMode) var presentationMode
    let settingName: LocalizedStringKey
    
    init(selectedItem: Binding<T?>) {
        self._selectedItem = selectedItem
        
        self.settingName = LocalizedStringKey("Picker")
    }
    

    var body: some View {
        NavigationView {
            Picker(selection: $selectedItem, label: Text(settingName)) {
                ForEach(T.allCases, id: \.self) { item in
                    Text(item()).tag(item as T?)
                }
            }.pickerStyle(.wheel)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        CustomButton(type: .plain,
                                     title: "Fertig",
                                     disabled: false,
                                     action: {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                    
                }
        }
    }
    
    func dismiss() {
        
    }
}
#Preview {
    @State var sex: Sex? = .female
    return PickerSheetView <Sex>(selectedItem: $sex)
        .presentationDetents([.medium])
}
