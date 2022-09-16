﻿;No dependencies

/**
 * Clicks with "Click", then moves the mouse to its initial position
 * @param coordinates "123 123" format
 */
ClickThenGoBack(coordinates) {
   MouseGetPos(&initX, &initY)
   Click(coordinates)
   MouseMove(initX, initY)
}

/**
 * Clicks by SendEventing the click, then moves the mouse to its initial position
 * @param coordinates "123 123" format
 */
ClickThenGoBack_Event(coordinates) {
   MouseGetPos(&initX, &initY)
   SendEvent("{Click " coordinates "}")
   MouseMove(initX, initY)
}

/**
 * Run("https://link.com") will run the link, but the browser might not get focused. This function makes sure it does
 */
RunLink(link) => (
   Run(link),
   WinWait("Google Chrome ahk_exe chrome.exe"),
   WinActivate("Google Chrome ahk_exe chrome.exe")
)

/**
 * Keeps searching for an image until it finds it
 * @param imageFile The path to the image
 * @param coordObj An optional object with x1,y1,x2,y2 properties to search for the image in
 * @returns an array with found X and Y coordinates
 */
WaitUntilImage(imageFile, coordObj?) {
   var := 0
   if !IsSet(coordObj) {
      coordObj := {
         x1: 0,
         y1: 0,
         x2: A_ScreenWidth,
         y2: A_ScreenHeight,
      }
   }
   While !var {
      var := ImageSearch(&imgX, &imgY, coordObj.x1, coordObj.y1, coordObj.x2, coordObj.y2, imageFile)
   }
   return [imgX, imgY]
}

/**
 * Searches for an image until it finds it, and then controlclicks on it
 */
WaitClick(imageFile) => (
   coords := WaitUntilImage(imageFile),
   ControlClick("X" coords[1] " Y" coords[2], "A")
)

/**
 * Change the transparency of the current window
 * @param whatCrement Specify a negative integer to increase transparency (lower number => lower visibility)
 */
TransAndProud(whatCrement) {
   howTrans := WinGetTransparent("A")

   if !howTrans
      howTrans := 255

   etgServer := howTrans + whatCrement

   Switch {
      Case etgServer >= 255: etgServer := "Off"
      Case etgServer <= 1: etgServer := 1
   }

   try WinSetTransparent(etgServer, "A")
}

/**
 * Make the current window completely untransparent
 */
Cis() {
   try WinSetTransparent(255, "A")
}

WriteFile(whichFile, text := "") => (
   fileObj := FileOpen(whichFile, "w"),
   fileObj.Write(text),
   fileObj.Close()
)

AppendFile(whichFile, text) {
   if FileExist(whichFile)
      fileObj := FileOpen(whichFile, "a")
   else
      fileObj := FileOpen(whichFile, "w")
   fileObj.Seek(0, 2)
   fileObj.Write(text)
   fileObj.Close()
}

ReadFile(whichFile) {
   fileObj := FileOpen(whichFile, "r")
   fileObj.Seek(0, 0)
   text := fileObj.Read()
   fileObj.Close()
   return text
}

ControlClick_Here(winTitle := "A", whichButton := "L") => (
   MouseGetPos(&locX, &locY),
   ControlClick("X" locX " Y" locY, winTitle, , whichButton)
)

WaitUntilPixChange_Relative(r_RelPos, timeout := 5) {
   MouseGetPos(&locX, &locY)
   initPix := []
   endPix := []
   time := A_TickCount

   for key, value in r_RelPos {
      if !RegexMatch(value, "(-?\d+),? (-?\d+)", &init_coords)
         return false
      initPix.Push(PixelGetColor(locX + init_coords[1], locY + init_coords[2]))
   }

   Loop {
      for key, value in r_RelPos {
         if !RegexMatch(value, "(-?\d*),? (-?\d*)", &end_coords)
            return false
         endPix.Push(PixelGetColor(locX + end_coords[1], locY + end_coords[2]))
      }
      for key, value in initPix {
         if value != endPix[key]
            break 2
      }
      endPix := []
      if A_TickCount - time > timeout * 1000
         return false
   }
   return true
}

SystemReboot() => Shutdown(2)

SystemPowerDown() => Shutdown(1)

RegexInFile(filePath, regex) {
   fileText := ReadFile(filePath)
   if !IsObject(regex) {
      if !RegexMatch(fileText, regex, &match) {
         TrayTip(regex " not found in " filePath)
         return false
      }
      return match
   }
   Matches := {}
   for key, value in regex {
      if !RegexMatch(fileText, value, &match) {
         TrayTip(value " not found in " filePath)
         continue
      }
      Matches.%key% := match
   }
   return Matches
}

RegexToFile(filePath_From, filePath_To, regex) => (
   match := RegexInFile(filePath_From, regex),
   WriteFile(filePath_To, match[0])
)

async(funcObj) => SetTimer(funcObj, -1)
