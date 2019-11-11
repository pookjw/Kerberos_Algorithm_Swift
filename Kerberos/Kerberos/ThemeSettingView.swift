//
//  ThemeSettingView.swift
//  Kerberos
//
//  Created by pook on 11/11/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct ThemeSettingView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    var body: some View {
        VStack{
            LogView()
                .padding([.top, .leading, .trailing], 10.0)
            List{
                NavigationLink(destination: ColorList(color: $enviromentClass.log_background_color, title: "Background")){
                    HStack{
                        Image(systemName: "rectangle.fill")
                            .foregroundColor(Color.blue)
                            .frame(width: 30)
                        Text("Background")
                    }
                }
                NavigationLink(destination: ColorList(color: $enviromentClass.log_overlay_color, title: "Overlay")){
                    HStack{
                        Image(systemName: "rectangle")
                            .foregroundColor(Color.blue)
                            .frame(width: 30)
                        Text("Overlay")
                    }
                }
                NavigationLink(destination: ColorList(color: $enviromentClass.log_text_color, title: "Text")){
                    HStack{
                        Image(systemName: "textformat")
                            .foregroundColor(Color.blue)
                            .frame(width: 30)
                        Text("Text")
                    }
                }
            }
        }
        .navigationBarTitle("Theme")
    }
}

struct ColorList: View{
    @Binding var color: Color
    var title: String
    
    let ColorList: [String: Color] = ["Black": .black, "Blue": .blue, "Gray": .gray, "Green": .green, "Orange": .orange, "Pink": .pink, "Purple": .purple, "Red": .red, "White": .white, "Yellow": .yellow]
    
    var body: some View{
        VStack{
            LogView()
                .padding([.top, .leading, .trailing], 10.0)
            List{
                ForEach(ColorList.keys.sorted(), id: \.self){ value in
                    Button(action: {self.color = self.ColorList[value]!}){
                        HStack{
                            if self.color == self.ColorList[value]{
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.blue)
                            }else{
                                Image(systemName: "circle")
                                    .foregroundColor(Color.gray)
                            }
                            Circle()
                                .foregroundColor(self.ColorList[value])
                                .frame(width: 30)
                            Text(value)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(title)
    }
}

struct ThemeSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSettingView()
    }
}
