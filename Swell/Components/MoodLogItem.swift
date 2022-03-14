//
//  MoodLogItem.swift
//  Swell
//
//  Created by Tanner Maasen on 3/13/22.
//

import SwiftUI

struct MoodLogItem: View {
    var selectedMood: Mood
    
    var body: some View {
        VStack {
            Text(selectedMood.emoji)
                .font(.system(size: 28))
            Text(selectedMood.text)
        }
        .padding()
    }
}

struct MoodLogItem_Previews: PreviewProvider {
    static var previews: some View {
        MoodLogItem(selectedMood: Mood.happy)
    }
}
