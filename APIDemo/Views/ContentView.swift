//
//  ContentView.swift
//  APIDemo
//
//  Created by Rishabh Raj on 07/04/20.
//  Copyright © 2020 Rishabh Raj. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var demoObjs = DemoObjectViewModel()
    
    var body: some View {
        List(demoObjs.objects) { object in
            VStack(alignment: .leading) {
                Text("ID:\(object.id ?? -1)")
                Text("Name:\(object.name ?? "No Name")")
                Text("Description:\(object.description ?? "No Desc")")
                Text("Open Issues Count: \(object.open_issues_count ?? -1)")
                Text("License: \(object.license?.key ?? "No License")")
                    .onAppear {
                        self.demoObjs.updateObjects(currentItem: object)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
