//
//  Audio.swift
//  Interactive Story
//
//  Created by Davide Callegari on 10/03/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import Foundation
import AudioToolbox


extension Story {
    var soundEffectName: String {
        switch self {
        case .droid, .home: return "HappyEnding"
        case .monster: return "Ominous"
        default: return "PageTurn"
        }
    }
    
    var soundEffectURL:URL {
        let path = Bundle.main.path(forResource: soundEffectName, ofType: "wav")!
        return URL(fileURLWithPath: path)
    }
}


class SoundEffectsPlayer {
    var sound: SystemSoundID = 0
    
    func playSoundFor(story: Story) {
        let soundUrl = story.soundEffectURL as CFURL
        AudioServicesCreateSystemSoundID(soundUrl, &sound)
        AudioServicesPlaySystemSound(sound)
    }
}
