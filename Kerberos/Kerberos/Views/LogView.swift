//
//  LogView.swift
//  Kerberos
//
//  Created by pook on 11/5/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct LogView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    var body: some View {
        ScrollView{
            Spacer()
                .frame(height: 5)
            HStack{
                Spacer()
                    .frame(width: 7)
                Text(self.enviromentClass.log)
                    .foregroundColor(self.enviromentClass.log_text_color)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
        }
            .background(self.enviromentClass.log_background_color)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(self.enviromentClass.log_overlay_color, lineWidth: 6)
            )
    }
}

/*
struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
*/
