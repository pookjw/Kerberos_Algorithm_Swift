//
//  ClientView.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct ClientView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    var body: some View {
        List{
            ForEach(self.enviromentClass.client_list, id: \.self.client_id_raw){ value in
                Text(value.client_id_raw)
            }
        }
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView()
    }
}
