---
title: Android App – IllumiNative
layout: lesson

links:
  - text: Design Files (Sketch)
    url: app-design/illuminative.sketch

---

# Design

Here are some design drafts for the mobile app to control the lamp. The source file (Sketch) can be found under the link at the very top of the page.

## Color Adjustment

<div class="row">
	<div class="col-sm-4"><zoom src="app-design/color-1.png" caption="Color adjustment warm"></zoom></div>
	<div class="col-sm-4"><zoom src="app-design/color-2.png" caption="Color adjustment cold"></zoom></div>
	<div class="col-sm-4"><zoom src="app-design/color-3.png" caption="Color adjustment offset (sun tracking enabled)"></zoom></div>
</div>

## Brightness & Sun Tracking

<div class="row">
	<div class="col-sm-4 offset-sm-2"><zoom src="app-design/brightness.png" caption="Brightness adjustment"></zoom></div>
	<div class="col-sm-4"><zoom src="app-design/sun-tracking.png" caption="Sun tracking settings"></zoom></div>
</div>

# Implementation

As the target platfrom is only Android for the moment, i will implement the app as a native Java program using the official [Android Studio IDE](https://developer.android.com/studio/index.html).

For the circular adjustment slider, i found a pre-made [widget by devadvance](https://github.com/devadvance/circularseekbar).

The [Bluetooth Chat Example](https://developer.android.com/samples/BluetoothChat/index.html) gives me a starting point for the bluetooth interface to my lamp.
