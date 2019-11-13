# Kerberos_Algorithm_Swift

![1](https://live.staticflickr.com/65535/49052608098_113f832194_o.png)

Not a real Kerberos. It doesn't communicate with actual servers. Just communicates with Swift object with Kerberos algorithm locally.

Used AES-128 with [krzyzanowskim/CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift). Coded with SwiftUI.

Supports iOS (not for iPadOS yet), macOS (Catalyst Project).

## Fundamental Algorithm

More Details can check at [Kerberos (protocol)](https://en.wikipedia.org/wiki/Kerberos_(protocol))

1. Client sends ID to AS. AS checks that Client is signed up. AS gives:

- messageA : TGS Session Key encrypted with the Client Secret Key

- messageB : TGT (client ID, TGS session key) encrypted with the TGS Secret Key

These are combined on Token1.

2. Client attempts to decrypt messageA, and client sends the following messages to the TGS

- messageC : messageB

- messageD : Authenticator (Client ID, timestamp) encrypted with the TGS Session Key (from messageA)

These are combined on Token2. Now Client knows TGS Session Key from messageA.

3. The TGS retrieves messageC and decrypts using TGS Secret key and gets TGS Session Key. Using this key, the TGS decrypts messageD and check timestamp, compare Client ID from C and D. If they match,

- messageE : Client-to-server ticket (Client ID, Server Session Key) encrypted using the Server Secret Key

- messageF : Server Session Key encypted using TGS Session Key (from messageC)

These are combined on Token3.

4. Client receives E and F. Now client knows Server Session Key from messageF (TGS Session Key can get from messageA)

- messageE : messageE from the previous step

- messageG : another Authenticator (Client ID, timestamp) encrypted using Server Session key 
 
 These are combined on Token4.
 
5. SS decrypts messageE using Server secret key and gets Server Session Key. Using this Server Session Key, SS decrypts messageG and compare Client ID. If match,

- messageH : the timestamp found in messageG

This is called on Token5.

6. Client gets messageH and check timestamp.

## How to use this

### Table

- [Building Project](#building-project)

- [Creating a new Client](#creating-a-new-client)

- [Creating a new Server](#creating-a-new-server)

- [Signing up Client to Server](#signing-up-client-to-server)

- [Select Client and Server to run algorithm](#select-client-and-server-to-run-algorithm)

- [Adjust Timeout and Delay value](#adjust-timeout-and-delay-value)

- [Running Algorithm](#running-algorithm)

- [Running Golden Ticket Exploit](#running-golden-ticket-exploit)

- [Running Algorithm Step By Step](#running-algorithm-step-by-step)

- [Change LogView Theme](#change-logView-theme)

### Buidling Project

1. Create a new Xcode Workspace.

2. Add Kerberos (this project) and [krzyzanowskim/CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) references to Workspace like below.

![9](https://live.staticflickr.com/65535/49053155291_048f5fd13b_o.png)

3. Set Signing with your Apple Developer ID.

4. Embed CryptoSwift.framework to Kerberos like below.

![10](https://live.staticflickr.com/65535/49053157401_ed62c19caf_o.png)

5. Build and Run!

### Creating a new Client

![3](https://live.staticflickr.com/65535/49027339926_3c0ebef5df_o.png)

Go to **Settings (gear icon) → Client List → Plus Button (located on right top)**

### Creating a new Server

![2](https://live.staticflickr.com/65535/49026826763_321fc957c6_o.png)

Go to **Settings (gear icon) → Server List → Plus Button (located on right top)**

### Signing up Client to Server

![3](https://live.staticflickr.com/65535/49026829953_0b71161fab_o.png)

Go to **Settings (gear icon) → Server List → Pencil Button (located on right top) → Select Server you want to sign up → Add item...  → Select Client you want to sign up**

### Select Client and Server to run algorithm

Select Client: Go to **Settings (gear icon) → Client List →  Touch Client you want to select**

Select Server: Go to **Settings (gear icon) → Server List →  Touch Server you want to select**

### Adjust Timeout and Delay value

Go to **Settings (gear icon)** and adjust them.

### Running Algorithm

![1](https://live.staticflickr.com/65535/49027558547_7b447e8948_o.png)

Touch **Play** button. If running algorithm was successful, you can see this message:

```
Requesting token1 to Authentication Server...
Creating token2...
Requesting token3 to Ticket Granting Service...
Creating token4...
Requesting token5 to Service Server...
Checking token5...
Success!
```

**Make sure that selected Client is signed up to selected Server!!! If it isn''t you will see AS.AS_ERROR.**

### Running Golden Ticket Exploit

![6](https://live.staticflickr.com/65535/49027566752_c45e020193_o.png)

Enable **Settings (gear icon) → Golden Ticket → Enable Exploit Mode**

Select Hacker to use Exploit Mode. Hacker, who is not signed up to selected Server, can login to selected Server using Kerberos Golden Ticket Exploit with selected Client ID, which is signed up to selected Server.

### Running Algorithm Step By Step

![7](https://live.staticflickr.com/65535/49053339987_d73435f460_o.png)

Toggle **Settings (gear icon) → Step By Step**

### Change LogView Theme

![8](https://live.staticflickr.com/65535/49053349852_b3bd1c7b8f_o.png)

Go to **Settings (gear icon) → Miscellaneous →  Theme Settings**

## To Do

- Fix SwiftUI EnviromentObject refresh bug: Added Refresh button. This is a SwiftUI bug. Apple should fix this. Check [here](https://stackoverflow.com/questions/57727478/refreshing-a-swiftui-list) to hack this.

- ~~Add Kerberos fundamental vulnerability~~ Done

- ~~Enhance timestamp~~ Done

- ~~Add LogView~~ Done

- More error handling

- Rich comments

- Multi Encryption Algorithm
