//
//  AntiSpyDetailModel.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 14.11.2023.
//

import UIKit

struct AntiSpyDetailModel: Hashable {
    let image: UIImage?
    let title: String
    let subtitle: String
    
    static let item: [AntiSpyDetailModel] = [
        AntiSpyDetailModel(image: UIImage(named: "component-7"),
                           title: "Wireless obscura",
                           subtitle: "All MAC addresses are unique. The first 3 bytes constitute the codes assigned by the IEEE registry to different vendors, which can be used to differentiate various manufacturers, while the last 3 bytes are allocated by the manufacturers themselves. Thus, a MAC address is equivalent to an identification number for a wireless network card. Using the MAC address, it is possible to find corresponding equipment and manufacturer information in certain databases.")
    ]
    
    static let items: [AntiSpyDetailModel] = [
        AntiSpyDetailModel(image: UIImage(named: "CheckingPowerOutlets"), 
                           title: "Checking Power Outlets",
                           subtitle: "Check the power outlets near the bed and bathroom, as hidden cameras might be placed in those sockets. These cameras usually require power and this location is ideal for capturing footage."),
        AntiSpyDetailModel(image: UIImage(named: "AirConditioningVent"),
                           title: "Air Conditioning Vent", 
                           subtitle: "The air conditioning vent in the room is considered a safe place to hide a camera. Cleaning tools usually don't wipe down the air conditioner. To detect a hidden camera, turn off the lights in the room, shine a flashlight into the air conditioning vent. If there's a bright spot that turns off, it's highly likely that a camera is there."),
        AntiSpyDetailModel(image: UIImage(named: "PictureFrameswithCameras"),
                           title: "Picture Frames with Cameras",
                           subtitle: "For hanging photographs in the room, this type of camera is individualistic, and the lens is typically located on the frame's surface, which can be seen with the naked eye."),
        AntiSpyDetailModel(image: UIImage(named: "TVInspection"),
                           title: "TV Inspection",
                           subtitle: "Look at the television in front of the bed. A camera obscura might be hidden near the TV."),
        AntiSpyDetailModel(image: UIImage(named: "PlantDecorations"),
                           title: "Plant Decorations",
                           subtitle: "These decorations with potted plants can give rise to suspicions, as people can easily hide cameras, especially in romantic hotels with many ornaments."),
        AntiSpyDetailModel(image: UIImage(named: "SofawithCamera"),
                           title: "Sofa with Camera",
                           subtitle: "A sofa can also be easily equipped with a camera obscura. Some people like to dig a hole in the sofa and then insert the camera, leaving only a small black hole."),
        AntiSpyDetailModel(image: UIImage(named: "SmokeAlarmCamera"),
                           title: "Smoke Alarm Camera",
                           subtitle: "Usually, the lens of a smoke alarm camera is installed inside, making it difficult to see the reflection point with a flashlight, making detection more challenging."),
    ]
}
