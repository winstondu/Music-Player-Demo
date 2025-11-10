//
//  Constants+MusicTrack.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/9/25.
//
import Foundation

// Hardcoded tracks from Taylor Swift's 1989 album (fetched from iTunes API)
let taylorSwift1989Tracks: [MusicTrack] = [
    MusicTrack(
        id: "1440935802",
        name: "Welcome To New York",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/8e/3a/a5/8e3aa5ba-7722-838d-7395-7f2e5b72a800/mzaf_14145571341541272816.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 212600
    ),
    MusicTrack(
        id: "1440935808",
        name: "Blank Space",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/57/dc/f4/57dcf476-1af6-3706-c0b4-aa2d97c702ce/mzaf_509502127790931850.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 231833
    ),
    MusicTrack(
        id: "1440935812",
        name: "Style",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/03/d3/e7/03d3e7ce-d066-1d5e-d8ec-94288603edba/mzaf_11334003269333631096.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 231000
    ),
    MusicTrack(
        id: "1440935820",
        name: "Out of the Woods",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/86/37/dd/8637dd40-bbbd-ed09-9c0d-cc802f5cfd21/mzaf_8766414241791346451.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 235800
    ),
    MusicTrack(
        id: "1440935829",
        name: "All You Had To Do Was Stay",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/e0/59/2a/e0592a45-da5b-0750-4e89-236eed2ee709/mzaf_8099361077434104774.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 193289
    ),
    MusicTrack(
        id: "1440936016",
        name: "Shake It Off",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/5e/10/7c/5e107c9b-5fe8-581a-5ea4-717903781d94/mzaf_13937309032449903025.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 219209
    ),
    MusicTrack(
        id: "1440936021",
        name: "I Wish You Would",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/df/cb/56/dfcb566d-ef33-c5df-04b5-67d2cc73a373/mzaf_16852456055802287441.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 207435
    ),
    MusicTrack(
        id: "1440936028",
        name: "Bad Blood",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/80/e6/a8/80e6a803-1117-cd3f-48da-a3e6799eea3c/mzaf_10174351058545549372.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 211933
    ),
    MusicTrack(
        id: "1440936036",
        name: "Wildest Dreams",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/84/fa/ad/84faad60-0a35-ddaf-ceb5-2ff09e0b0e5a/mzaf_4333199558904738055.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 220433
    ),
    MusicTrack(
        id: "1440936195",
        name: "How You Get the Girl",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/ba/83/49/ba834950-82cd-b435-0760-b1d24e9eafa1/mzaf_6100216268001075273.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 247533
    ),
    MusicTrack(
        id: "1440936201",
        name: "This Love",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/b5/bc/2d/b5bc2d4d-fdd2-f803-d30f-5badd917b82c/mzaf_6131896205773781695.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 250100
    ),
    MusicTrack(
        id: "1440936203",
        name: "I Know Places",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/5d/26/32/5d2632fc-68fc-68be-9b11-1b47f92faed2/mzaf_12306884528528576424.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 195700
    ),
    MusicTrack(
        id: "1440936206",
        name: "Clean",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/66/4b/ac/664bac15-9db3-dc6b-15e9-34277cda6652/mzaf_11558704568117920604.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 271000
    ),
    MusicTrack(
        id: "1851142812",
        name: "5-Minute Sleep BGM for the End of a Long Day",
        artist: "Sleep-inducing BGM that will make you fall asleep in 5 minutes",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/8d/a9/ec/8da9eca5-1e42-b4a2-e8d0-56f5be56228e/mzaf_17121229921824018351.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/df/87/42/df8742c5-5865-41db-9103-1e142a044f88/4550713476341_cover.png/100x100bb.jpg"),
        trackTimeMillis: 131072
    )
]
