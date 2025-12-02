//
//  TabBarView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 30/11/2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            ActivityView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Activity")
                }
                .tag(1)
            
            AddView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(2)
            
            BudgetView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Budget")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.black)
    }
}

#Preview {
    TabBarView()
}
