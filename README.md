# PointerKit 

<p align="center">
<img src="readme-resources/PointerKit.gif" style="max-height: 4480px;" alt="PanelKit for iOS">
<br>
<i>A Magic Mouse connected to an iPad running <a href="https://itunes.apple.com/us/app/pixure-professional-pixel-art-studio/id893400841?mt=8">Pixure</a> with <a href="https://github.com/louisdh/panelkit">PanelKit</a>.</i>
</p>


## About
PointerKit is a proof of concept framework to use a pointing device on iOS. This is done via a multipeer connection between a Mac and an iOS device. The pointer movement is captured by the Mac app, after which it's send to the receiving iOS device (over Bluetooth or Wi-Fi).

This project uses [PTFakeTouch](https://github.com/PugaTang/PTFakeTouch) for faking touches.

## Implementing
If you're an app developer, you can add mouse support by compiling and including the PointerKit framework (from ```RemotePointer.xcworkspace```) and adding a couple lines of code to your project:

```
var manager: PointerManager!

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
	
    manager = PointerManager(with: self, in: UIApplication.shared.keyWindow!)

    manager.showConnector()
}
```

