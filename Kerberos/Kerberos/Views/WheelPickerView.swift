//
//  WheelPickerView.swift
//  Kerberos
//
//  Created by pook on 11/12/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct WheelPickerView: View{
    @EnvironmentObject var enviromentClass: EnviromentClass
    @Binding var value: Int
    var title: String
    var showLogView: Bool
    
    var body: some View{
        VStack{
            if self.showLogView{
                LogView()
                    .padding(.horizontal, 10.0)
            }
            HStack{
                Spacer()
                Picker(selection: $value, label:
                Text("")){
                    ForEach(0...120, id: \.self){ number in
                        Text(String(number)).tag(number)
                    }
                }
                .scaledToFit()
                Spacer()
            }
                //.offset(x: -100)
                //.padding(.horizontal, 99999999999.0)
        }
        .navigationBarTitle(title)
    }
}

/*
 struct WheelPickerView_Previews: PreviewProvider {
 static var previews: some View {
 WheelPicker()
 }
 }*/
