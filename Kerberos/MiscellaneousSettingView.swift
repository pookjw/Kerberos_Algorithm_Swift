//
//  MiscellaneousSettingsView.swift
//  Kerberos
//
//  Created by pook on 11/11/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct MiscellaneousSettingsView: View {
    var body: some View {
        List{
            NavigationLink(destination: ThemeSettingView()){
                Image(systemName: "paintbrush")
                    .foregroundColor(Color.blue)
                    .frame(width: 30)
                Text("Theme Setting")
            }
            .navigationBarTitle("Miscellaneous")
        }
    }
}

struct MiscellaneousSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MiscellaneousSettingsView()
    }
}
