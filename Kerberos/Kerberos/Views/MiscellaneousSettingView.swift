//
//  MiscellaneousSettingsView.swift
//  Kerberos
//
//  Created by pook on 11/11/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct MiscellaneousSettingsView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    var body: some View {
        List{
            NavigationLink(destination: ThemeSettingsView()){
                Image(systemName: "paintbrush")
                    .foregroundColor(Color.blue)
                    .frame(width: 30)
                Text("Theme Settings")
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
