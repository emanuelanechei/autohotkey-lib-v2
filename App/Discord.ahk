#Include <Paths>
#Include <Image>

Class Discord {
   
   static exeTitle  := "ahk_exe Discord.exe"
   static winTitle  := "Discord " this.exeTitle
   static exception := "Updater" ;Don't consider the window to be discord if it has this in its title
   static path := Paths.LocalAppData "\Discord\app-1.0.9007\Discord.exe" 
   
   static winObj := Win({
      winTitle: this.winTitle,         
      exePath: this.path,
      exception: this.exception
   })
   
   static Emoji() => Send("^e")

   static Gif() => Send("^g")

   static React() => WaitClick(Paths.Ptf["react"])
   static Edit()  => WaitClick(Paths.Ptf["edit"])
   static Reply() => WaitClick(Paths.Ptf["reply"])

}
