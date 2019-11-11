//
//  ContentView.swift
//  CoreDataSwiftUI
//
//  Created by Pavel Bondar on 11/11/19.
//  Copyright © 2019 Pavel Bondar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
//    @FetchRequest(entity: Order.entity(),
//                  sortDescriptors: [
//                    NSSortDescriptor(keyPath: \Order.drink, ascending: true)
//    ]) var orders: FetchedResults<Order>
    @FetchRequest(fetchRequest: Order.getAllOrders()) var orders: FetchedResults<Order>
    
    @State private var newOrder = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("New order")) {
                    HStack {
                        TextField("New order", text: $newOrder)
                        Button(action: {
                            let order = Order(context: self.managedObjectContext)
                            order.drink = self.newOrder
                            order.createdAt = Date()
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                            self.newOrder = ""
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                        })
                    }
                }
                Section(header: Text("Your Orders")) {
                    ForEach(self.orders, id: \.self) { order in
                        OrderItemView(drink: order.drink, createAt: "\(order.createdAt)")
                    }.onDelete(perform: removeOrder)
                }
            }.navigationBarTitle(Text("Order View"))
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func removeOrder(at offsets: IndexSet) {
        for index in offsets {
            let order = orders[index]
            managedObjectContext.delete(order)
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct OrderItemView: View {
    
    var drink: String = ""
    var createAt: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(drink).font(.headline)
                Text(createAt).font(.caption)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
