//
//  ContentView.swift
//  EngManu
//
//  Created by Shira on 2023/08/24.
//

import SwiftUI

struct ManualItem: Identifiable, Decodable {
    var id: UUID
    var ジャンル: String
    var 日本語: String
    var 英語: String

    enum CodingKeys: String, CodingKey {
        case ジャンル, 日本語, 英語
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ジャンル = try container.decode(String.self, forKey: .ジャンル)
        日本語 = try container.decode(String.self, forKey: .日本語)
        英語 = try container.decode(String.self, forKey: .英語)
        id = UUID() // idを生成する
    }
}


func loadManualData() -> [ManualItem] {
    guard let url = Bundle.main.url(forResource: "manual", withExtension: "json") else {
        print("Failed to locate manual.json in bundle.")
        return []
    }

    do {
        let data = try Data(contentsOf: url)
        let manualItems = try JSONDecoder().decode([ManualItem].self, from: data)
        return manualItems
    } catch {
        print("Error decoding manual.json: \(error)")
        return []
    }
}


struct GenreSelectionView: View {
    let manualItems = loadManualData()
    var genres: [String] {
        Array(Set(manualItems.map { $0.ジャンル })).sorted()
    }

    var body: some View {
        NavigationView {
            List(genres, id: \.self) { genre in
                NavigationLink(destination: ManualListView(for: genre)) {
                    Text(genre)
                }
            }
            .navigationBarTitle("シチュエーション")
        }
    }
}

struct ManualListView: View {
    let genre: String
    let manualItems: [ManualItem]

    init(for genre: String) {
        self.genre = genre
        self.manualItems = loadManualData().filter { $0.ジャンル == genre }
    }

    var body: some View {
        List(manualItems) { item in
            NavigationLink(destination: DetailView(item: item)) {
                Text(item.日本語)
            }
        }
        .navigationBarTitle(genre)
    }
}

struct DetailView: View {
    let item: ManualItem

    var body: some View {
        VStack {
            Spacer()
            Text(item.英語)
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationBarTitle(item.日本語, displayMode: .inline)
    }
}

struct ContentView: View {
    var body: some View {
        GenreSelectionView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
