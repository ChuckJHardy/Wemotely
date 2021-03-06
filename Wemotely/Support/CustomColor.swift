import UIKit

// https://medium.com/ios-os-x-development/ios-extend-uicolor-with-custom-colors-93366ae148e6

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }

    // swiftlint:disable nesting
    struct CustomColor {
        // https://developer.apple.com/ios/human-interface-guidelines/visual-design/color/
        struct Apple {
            static let Red = UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1)
            static let Orange = UIColor(red: 255 / 255, green: 149 / 255, blue: 0 / 255, alpha: 1)
            static let Yellow = UIColor(red: 255 / 255, green: 204 / 255, blue: 0 / 255, alpha: 1)
            static let Green = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
            static let TealBlue = UIColor(red: 90 / 255, green: 200 / 255, blue: 250 / 255, alpha: 1)
            static let Blue = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1)
            static let Purple = UIColor(red: 88 / 255, green: 86 / 255, blue: 214 / 255, alpha: 1)
            static let Pink = UIColor(red: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1)
        }

        struct Green {
            static let Fern = UIColor(netHex: 0x6ABB72)
            static let MountainMeadow = UIColor(netHex: 0x3ABB9D)
            static let ChateauGreen = UIColor(netHex: 0x4DA664)
            static let PersianGreen = UIColor(netHex: 0x2CA786)
        }

        struct Blue {
            static let PictonBlue = UIColor(netHex: 0x5CADCF)
            static let Mariner = UIColor(netHex: 0x3585C5)
            static let CuriousBlue = UIColor(netHex: 0x4590B6)
            static let Denim = UIColor(netHex: 0x2F6CAD)
            static let Chambray = UIColor(netHex: 0x485675)
            static let BlueWhale = UIColor(netHex: 0x29334D)
        }

        struct Violet {
            static let Wisteria = UIColor(netHex: 0x9069B5)
            static let BlueGem = UIColor(netHex: 0x533D7F)
        }

        struct Yellow {
            static let Energy = UIColor(netHex: 0xF2D46F)
            static let Turbo = UIColor(netHex: 0xF7C23E)
        }

        struct Orange {
            static let NeonCarrot = UIColor(netHex: 0xF79E3D)
            static let Sun = UIColor(netHex: 0xEE7841)
        }

        struct Red {
            static let TerraCotta = UIColor(netHex: 0xE66B5B)
            static let Valencia = UIColor(netHex: 0xCC4846)
            static let Cinnabar = UIColor(netHex: 0xDC5047)
            static let WellRead = UIColor(netHex: 0xB33234)
        }

        struct Gray {
            static let AlmondFrost = UIColor(netHex: 0xA28F85)
            static let WhiteSmoke = UIColor(netHex: 0xEFEFEF)
            static let Iron = UIColor(netHex: 0xD1D5D8)
            static let IronGray = UIColor(netHex: 0x75706B)
        }
    }
    // swiftlint:enable nesting
}
