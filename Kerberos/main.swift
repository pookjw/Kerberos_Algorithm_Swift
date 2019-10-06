//
//  main.swift
//  Kerberos
//
//  Created by pook on 10/3/19.
//  Copyright © 2019 pook. All rights reserved.
//

import Foundation

var session = Session()
var client = Client(client_id: randomArray(), client_key: randomArray(), client_iv: randomArray(), session: &session)
client.token1 = try session.as.stage2(client_id: client.client_id)
client.token2 = try client.stage3()
client.token3 = try session.tgs.stage4(token2: client.token2)
client.token4 = try client.stage5()
client.token5 = try session.ss.stage6(token4: client.token4)
try client.stage7()
print("Success!")
