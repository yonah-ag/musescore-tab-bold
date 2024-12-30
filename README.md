# MuseScore Bold Tab Plugin 1.2
Plugin to display TAB fret numbers in a bold font, either to selected measures or to the whole score. The plugin works on a per voice basis and offers a selection of fonts which are supported by the musescore.com website player.

![01](https://github.com/yonah-ag/musescore-tab-bold/blob/main/images/TABBold1.2.png)

### License

Copyright (C) 2024 yonah_ag

This program is free software; you can redistribute it or modify it under the terms of the GNU General Public License version 3 as published by the Free Software Foundation and appearing in the LICENSE file.  
See https://github.com/yonah-ag/musescore-tab-bold/blob/main/LICENSE

### Revision History

+ v1.0 | 2023.02.18 | Initial release
+ v1.1 | 2023.04.09 | Added support for small notes
+ v1.2 | 2024.12.30 | Add full remove option; Save settings

### Installation

_Note: This plugin requires version 3.x of MuseScore._

+ Download **TabBold 1.2.qml** then follow the handbook instructions: https://musescore.org/en/handbook/3/plugins

### Using the Plugin

• Set the string spacing and font size to match the stave settings in the score.  
• Select a font face and select the voice to be made bold.  
• Select a range of measures, or use without selection to apply to all, then press **Apply**.  
• If the results need adjusting then press **Undo** and adjust the settings.
 
 The offset fields can be used to nudge the bold text left, right, up and down and should be set before pressing Apply.  

 To remove bold tab from a score use the **Remove** button.  
 Note that this works by removing bold, numeric staff texts from the entire score.  
 If you need to protect bold, numeric texts from removal then add a single space at the start and end.
