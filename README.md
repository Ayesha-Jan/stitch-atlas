# 🧶🗺️ Stitch Atlas

**Stitch Atlas** is a Flutter app that celebrates global textile traditions while giving users a creative space to design their own stitch patterns. Whether you're an artist, a fiber nerd, or a cultural explorer, Stitch Atlas lets you map, learn, and make.

---

## Features

### Home Page
- Navigate to:
  - **🧶 Designer**: Create your own stitch patterns
  - **🌍 Explorer**: Discover textile traditions around the world

---

### Designer Page

Choose your mode and customize your creative canvas:

- **Modes**:
  - Crochet
  - Knit
  - Colour
- **Grid Size**: Set your own dimensions (e.g. 25x25)
- Tap "Generate grid" to open a working grid

---

### Grid Page

Design your stitch pattern with ease:

- **Undo / Redo** support.
- **Zoom slider** for grid magnification.
- **Stitch Palette**: Choose symbols for Knit/Crochet modes.
- **Color Picker**: Select colors for Color mode.

---

### Explorer Page

Explore the textile traditions of the world:

- Interactive map with tappable region markers
- Regions are defined in a local JSON file
- Tap a marker to view full details, including:
  - Region
  - Countries
  - Culture
  - Description
  - Image
  - External source link (Wikipedia)
 
## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / Xcode or physical device

### Install and Run
    
    git clone https://github.com/Ayesha-Jan/stitch-atlas.git
    cd stitch-atlas
    flutter pub get
    flutter run

---

## Project Structure

<pre> stitch-atlas/ 
  lib/
  ├── main.dart
  ├── pages/
      ├── home.dart
      ├── designer.dart
      ├── grid.dart
      ├── explorer.dart
      ├── mode.dart
  /assets
  ├── images/
      ├── designs/
      ├── patterns/
  ├── crochet_symbols/ 
  ├── knit_symbols/
  ├── data/
      ├── regions.json
</pre>

---

Knit symbol graphics by [@marnen](https://github.com/marnen/knitting_symbols)! Thanks for your open-source contribution!

## Author

Developed by: Ayesha A. Jan  
Email: Ayesha.Jan@stud.srh-campus-berlin.de  
🎓 BST Operating Systems Project – 2025

