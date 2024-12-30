/* MuseScore Plugin: Bold Tab
 *
 * Copyright © 2023 yonah_ag
 *
 *  This program is free software; you can redistribute it or modify it under
 *  the terms of the GNU General Public License version 3 as published by the
 *  Free Software Foundation and appearing in the accompanying LICENSE file.
 *
 *  Description
 *  -----------
 *  Change TAB fret numbers to bold text
 *
 *  Releases
 *  --------
 *  1.0 : 18 Feb 2023 - Initial release
 *  1.1 : 09 Apr 2023 - Allow for small notes
 */

import MuseScore 3.0
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

MuseScore
{
   description: "Bold Tab 1.1";
   requiresScore: true;
   version: "1.1";
   menuPath: "Plugins.Bold Tab";

   pluginType: "dialog";
   width:  220;
   height: 200;

   property var pSize: 9.0; // fret font size
   property var pXorg: 0.75 // X origin
   property var pYorg: -0.6 // Y origin
   property var smAll: 0.7 // Small note factor
   
// =============================================================
//
//                       Parameter Defaults
//
// =============================================================
  
   property var pXoff: 0; // text X-Offset
   property var pYoff: 0; // text Y-Offset
   property var pYspc: 1.5 // string spacing
   property var pVox: 0 // Voice
   property var pFont: ""; // font face
   property var sSize: 0.0 // small font size
   property var sYoff: 0.0 // small Y-Offset
   
// =============================================================

   onRun:
   {
      txtSize.text = pSize;
      txtXoff.text = pXoff;
      txtYoff.text = pYoff;
      txtYspc.text = pYspc;
   }

   function undoBold()
   {
      cmd("undo");
   }
   
   function setBold()
   {
      if(isNaN(txtSize.text))
        pSize = 9
      else {
         pSize = 1 * txtSize.text;
         if (pSize < 6)
            pSize = 6
         else if (pSize > 20)
            pSize = 20;
      }

      if(isNaN(txtXoff.text))
         pXoff = pXorg
      else
         pXoff = txtXoff.text/100 + pXorg;

      if(isNaN(txtYoff.text))
         pYoff = pYorg
      else
         pYoff = txtYoff.text/100 + pYorg;

      if(isNaN(txtYspc.text))
         pYspc = 1.5
      else
         pYspc = 1 * txtYspc.text;
         
      pVox = txtVox.currentIndex;
      pFont = txtFont.currentText;
      sSize = smAll * pSize;
      sYoff = smAll * pYoff;

      var args = Array.prototype.slice.call(arguments, 1);
      var staveBeg;
      var staveEnd;
      var tickEnd;
      var rewindMode;
      var toEOF;
      var cursor = curScore.newCursor();

      cursor.rewind(Cursor.SELECTION_START);
      if (cursor.segment) {
         staveBeg = cursor.staffIdx;
         cursor.rewind(Cursor.SELECTION_END);
         staveEnd = cursor.staffIdx;
         if (!cursor.tick) {
            toEOF = true;
         }
         else
         {
            toEOF = false;
            tickEnd = cursor.tick;
         }
         rewindMode = Cursor.SELECTION_START;
      }
      else
      {
         staveBeg = 0; // no selection
         staveEnd = curScore.nstaves - 1;
         toEOF = true;
         rewindMode = Cursor.SCORE_START;
      }
      curScore.startCmd();
      for (var stave = staveBeg; stave <= staveEnd; ++stave)
      {
         cursor.staffIdx = stave;
         cursor.rewind(rewindMode);
         cursor.staffIdx = stave;
         cursor.voice = pVox;
         while (cursor.segment && (toEOF || cursor.tick < tickEnd))
         {
            if(cursor.element)
            {
               if(cursor.element.type == Element.CHORD)
               {
                  var notes = cursor.element.notes;
                  for (var ii = 0; ii < notes.length; ii++)
                  {
                     if(notes[ii].visible)
                     {
                        var txt = newElement(Element.STAFF_TEXT);
                        txt.text = notes[ii].fret;
                        txt.color = notes[ii].color;
                        txt.placement = Placement.ABOVE;
                        txt.align = 2; // LEFT = 0, RIGHT = 1, HCENTER = 2, TOP = 0, BOTTOM = 4, VCENTER = 8, BASELINE = 16
                        txt.fontFace = pFont;
                        txt.offsetX = pXoff;
                        if (notes[ii].small) {
                           txt.offsetY = pYspc * notes[ii].string + sYoff;
                           txt.fontSize = sSize;
                        }
                        else {
                           txt.offsetY = pYspc * notes[ii].string + pYoff;
                           txt.fontSize = pSize;
                        }
                        txt.fontStyle = 1;
                        txt.autoplace = false;
                        notes[ii].color = "#ffffff";
                        cursor.add(txt);
                     }
                  }
               }
            }
            cursor.next();
         }
      }
      curScore.endCmd();
   }

// =============================================================
//
//                          User Interface      
//
// =============================================================

   GridLayout { id: winUI
   
      anchors.fill: parent
      anchors.margins: 5
      columns: 3
      columnSpacing: 0
      rowSpacing: 0

      Label { id: lblYspc
         visible : true
         text: "String Spacing"
      }
      TextField { id: txtYspc
         visible: true
         enabled: true
         Layout.preferredWidth: 50
         Layout.preferredHeight: 25
         text: "0"
      }
      Button { id: btnApply
         visible: true
         enabled: true
         Layout.preferredWidth: 60
         Layout.preferredHeight: 25
         text: "Apply"
         onClicked: setBold()
      }
      Label { id: lblFont
         visible : true
         text: "Font face"
         Layout.preferredWidth: 75
      }
      ComboBox { id: txtFont
         visible: true
         enabled: true
         Layout.preferredWidth: 120
         Layout.preferredHeight: 25
         Layout.columnSpan: 2
         currentIndex: 0
         model: ListModel { id: selFont
            ListElement { text: "FreeSans"  }
            ListElement { text: "FreeSerif" }
            ListElement { text: "Edwin" }
            ListElement { text: "Leland" }
            ListElement { text: "Arial" }
            ListElement { text: "Courier New" }
            ListElement { text: "Georgia" }
            ListElement { text: "Trebuchet MS" }
            ListElement { text: "Verdana" }
         }
      }
      Label { id: lblSize
         visible : true
         text: "Font size"
         Layout.preferredWidth: 75
      }
      TextField { id: txtSize
         visible: true
         enabled: true
         Layout.preferredWidth: 50
         Layout.preferredHeight: 25
         text: "0"
      }
      Label { id: lblSpc3 // spacer
         visible: true
         text: " 6.0 to 20.0"
      }
      Label { id: lblXoff
         visible : true
         text: "X-Offset"
      }
      TextField { id: txtXoff
         visible: true
         enabled: true
         Layout.preferredWidth: 50
         Layout.preferredHeight: 25
         text: "0"
      }
      Label { id: lblSpc1 // spacer
         visible: true
         text: "-50  to +50"
      }
      Label { id: lblYoff
         visible : true
         text: "Y-Offset"
      }
      TextField { id: txtYoff
         visible: true
         enabled: true
         Layout.preferredWidth: 50
         Layout.preferredHeight: 25
         text: "0"
      }
      Label { id: lblSpc2 // spacer
         visible: true
         text: "-50  to +50 "
      }
      Label { id: lblVox
         visible : true
         text: "Voice"
      }
      ComboBox { id: txtVox
         visible: true
         enabled: true
         Layout.preferredWidth: 50
         Layout.preferredHeight: 25
         currentIndex: 0
         model: ListModel { id: selVox
            ListElement { text: "1"  }
            ListElement { text: "2" }
            ListElement { text: "3" }
            ListElement { text: "4" }
         }
      }
      Button { id: btnUndo
         visible: true
         enabled: true
         Layout.preferredWidth: 60
         Layout.preferredHeight: 25
         text: "Undo"
         onClicked: undoBold()
      }
   } // GridLayout
}
