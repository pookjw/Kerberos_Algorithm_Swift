//
//  GTView.swift
//  Kerberos
//
//  Created by pook on 11/7/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct GTView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    var body: some View {
        List{
            Toggle(isOn: $enviromentClass.GTMode){
                Text("Golden Ticket Exploit Mode")
            }
            if self.enviromentClass.GTMode{
                ForEach(0..<self.enviromentClass.client_list.count, id: \.self){ value in
                    HStack{
                        Button(action: {self.enviromentClass.selected_hacker = value}){
                            HStack{
                                if self.enviromentClass.selected_hacker == value{
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.blue)
                                }else{
                                    Image(systemName: "circle")
                                        .foregroundColor(Color.gray)
                                }
                                Text(self.enviromentClass.client_list[value].client_id.toString)
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
            .navigationBarTitle(Text("Golden Ticket"), displayMode: .inline)
    }
}

struct GTView_Previews: PreviewProvider {
    static var previews: some View {
        GTView()
    }
}
