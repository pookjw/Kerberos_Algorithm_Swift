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
                //.padding([.top, .leading, .trailing], 10.0)
            List{
                NavigationLink(destination: ColorList(color: $enviromentClass.log_background_color, title: "Background")){
                    HStack{
                        Image(systemName: "rectangle.fill")
                            .foregroundColor(Color.blue)
                            .frame(width: 30)
                        Text("Background")
                        Spacer()
                        Circle()
                            .foregroundColor(self.enviromentClass.log_background_color)
                            .frame(width: 30)
                    }
                }
                NavigationLink(destination: ColorList(color: $enviromentClass.log_overlay_color, title: "Overlay")){
                    HStack{
                        Image(systemName: "rectangle")
                            .foregroundColor(Color.blue)
                            .frame(width: 30)
                        Text("Overlay")
                        Spacer()
                        Circle()
                            .foregroundColor(self.enviromentClass.log_overlay_color)
                            .frame(width: 30)
                    }
                }
                NavigationLink(destination: ColorList(color: $enviromentClass.log_text_color, title: "Text")){
                    HStack{
                        Image(systemName: "textformat")
                            .foregroundColor(Color.blue)
                            .frame(width: 30)
                        Text("Text")
                        Spacer()
                        Circle()
                            .foregroundColor(self.enviromentClass.log_text_color)
                            .frame(width: 30)
                    }
                }
                NavigationLink(destination: WheelPickerView(value: $enviromentClass.log_line_spacing, title: "Spacing", showLogView: true)){
                    Image(systemName: "text.cursor")
                        .foregroundColor(Color.blue)
                        .frame(width: 30)
                    Text("Line Spacing")
                    Spacer()
                    Text("Spacing: \(self.enviromentClass.log_line_spacing)")
                        .foregroundColor(Color.gray)
                }
            }
        }
        .navigationBarTitle("Theme")
    }
}

struct ColorList: View{
    @Binding var color: Color
    var title: String
    
    let ColorList: [String: Color] = ["Black": .black, "Blue": .blue, "Clear": .clear, "Gray": .gray, "Green": .green, "Orange": .orange, "Pink": .pink, "Purple": .purple, "Red": .red, "White": .white, "Yellow": .yellow]
    
    var body: some View{
        VStack{
            LogView()
            List{
                ForEach(ColorList.keys.sorted(), id: \.self){ value in
                    Button(action: {self.color = self.ColorList[value]!}){
                        HStack{
                            Circle()
                                .foregroundColor(self.ColorList[value])
                                .frame(width: 30)
                            Text(value)
                            Spacer()
                            if self.color == self.ColorList[value]{
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.blue)
                            }else{
                                Image(systemName: "circle")
                                    .foregroundColor(Color.gray)
                            }
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
