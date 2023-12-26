//
//  ContentView.swift
//  Vollmed
//
//  Created by Arthur Gabriel on 25/12/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(
                    title: { Text("Home") },
                    icon: { Image(systemName: "house") }
                )
            }
            NavigationStack {
                MyAppointmentsView()
            }
            .tabItem {
                Label(
                    title: { Text("Consultas") },
                    icon: { Image(systemName: "calendar") }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
