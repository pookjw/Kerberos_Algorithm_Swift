//
//  StepListView.swift
//  Kerberos
//
//  Created by pook on 11/12/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct StepListView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    let kerberos: Kerberos
    var body: some View {
        List{
            if kerberos.hacker == nil{
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.stage1(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 1")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.blue)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.stage2(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 2")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.blue)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.stage3(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 3")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.blue)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.stage4(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 4")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.blue)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.stage5(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 5")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.blue)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.stage6(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 6")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.blue)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.kerberos.clear_all()
                        self.enviromentClass.return_code = 0
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Clear All Tokens")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.blue)
                                .scaleEffect(1.5)
                        }
                    }
                }
            }else{
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.gt_stage1(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 1")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.orange)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.gt_stage2(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 2")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.orange)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.gt_stage3(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 3")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.orange)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.gt_stage4(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 4")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.orange)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.enviromentClass.return_code = self.kerberos.gt_stage5(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Stage 5")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.orange)
                                .scaleEffect(1.5)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        self.kerberos.clear_all()
                        self.enviromentClass.return_code = 0
                        self.enviromentClass.showAlert = true
                    }){
                        HStack{
                            Text("Clear All Tokens")
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(Color.orange)
                                .scaleEffect(1.5)
                        }
                    }
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(kerberos.hacker == nil ? Color.blue : Color.orange,
                        lineWidth: 6)
        )
            .padding(.all, 10.0)
    }
}


/*
 struct StepListView_Previews: PreviewProvider {
 static var previews: some View {
 StepListView()
 }
 }*/
