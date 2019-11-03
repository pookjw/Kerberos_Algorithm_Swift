//
//  SettingView.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    
    var closeButton: some View{
        Button(action: {self.enviromentClass.showSettingSheet.toggle()}){
            Image(systemName: "xmark")
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: ClientView()){
                    Text("d")
                }
            }
            .navigationBarTitle("Kerberos Settings", displayMode: .inline)
            .navigationBarItems(trailing: closeButton)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
