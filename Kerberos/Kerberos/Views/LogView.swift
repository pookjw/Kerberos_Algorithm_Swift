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
                    .foregroundColor(Color.green)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
        }
            .background(Color.black)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray, lineWidth: 6)
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
