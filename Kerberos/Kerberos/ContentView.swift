//
//  ContentView.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    
    var openSheetButton: some View{
        Button(action: {self.enviromentClass.showSettingSheet.toggle()}){
            Image(systemName: "gear")
        }
    }
    
    var body: some View {
        NavigationView{
            Button(action: {runKerberos(servers: &session_1, client: &client_1)}){
                Text("Run")
            }
                .navigationBarTitle("Kerberos")
                .navigationBarItems(trailing: HStack{
                    openSheetButton
                })
                .sheet(isPresented: $enviromentClass.showSettingSheet){
                    SettingView()
                        .environmentObject(self.enviromentClass)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
