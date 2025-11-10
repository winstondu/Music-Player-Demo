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
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/3e/1c/4c/3e1c4c8f-d870-de09-c793-1d3256b5fc40/mzaf_17159063720592691370.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 219209
    ),
    MusicTrack(
        id: "1440936017",
        name: "I Wish You Would",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/15/2d/a4/152da416-3fd4-6f6b-2b4d-bb5c8d3dda01/mzaf_4042333788870806308.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 207435
    ),
    MusicTrack(
        id: "1440936018",
        name: "Bad Blood",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/90/4b/1d/904b1de8-4b16-8356-8e42-f48aac7a4456/mzaf_2653845612453929960.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 211933
    ),
    MusicTrack(
        id: "1440936019",
        name: "Wildest Dreams",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/7b/b1/6e/7bb16ee7-2e8e-ff03-a470-f67b4f8e96c5/mzaf_10926205883691838192.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 220433
    ),
    MusicTrack(
        id: "1440936020",
        name: "How You Get the Girl",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/46/2b/e6/462be67c-d4bd-e4d4-5f7f-e00e75feeca9/mzaf_1353506682882253967.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 247533
    ),
    MusicTrack(
        id: "1440936021",
        name: "This Love",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/32/56/9c/32569c2a-8f23-ea96-c5c9-fd48d3668ee1/mzaf_8849668089374686524.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 250100
    ),
    MusicTrack(
        id: "1440936022",
        name: "I Know Places",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/da/f1/02/daf10256-ea76-b57b-e835-43e65e3e7e09/mzaf_10382368086651506026.plus.aac.p.m4a"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/09/01/16/090116af-770e-23da-21a9-6bd30782eda5/00843930013562.rgb.jpg/100x100bb.jpg"),
        trackTimeMillis: 195700
    ),
    MusicTrack(
        id: "1440936023",
        name: "Clean",
        artist: "Taylor Swift",
        previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/b5/39/c5/b539c5d1-d13c-15e1-5b9a-34d0e8c77dc2/mzaf_16968155372253829434.plus.aac.p.m4a"),
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
