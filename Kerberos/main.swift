//
//  main.swift
//  Kerberos
//
//  Created by pook on 10/3/19.
//  Copyright © 2019 pook. All rights reserved.
//

import Foundation

print("Initializing session...")
var session = Session()
print("Initializing client...")
var client = Client(client_id: randomArray(), client_key: randomArray(), client_iv: randomArray(), session: &session)
print("Requesting token1 to Authentication Server...")
client.token1 = try session.as.stage2(client_id: client.client_id)
print("Creating token2...")
client.token2 = try client.stage3()
print("Requesting token3 to Ticket Granting Service...")
client.token3 = try session.tgs.stage4(token2: client.token2)
print("Creating token4...")
client.token4 = try client.stage5()
print("Requesting token5 to Service Server...")
client.token5 = try session.ss.stage6(token4: client.token4)
print("Checking token5...")
try client.stage7()
print("Success!")
