#Include <Paths>
#Include <Utils\Win>

Class Gimp {

	static process   := "gimp-2.10.exe"
	static exeTitle  := "ahk_exe " this.process
	static winTitle  := this.exeTitle
	static path      := A_ProgramFiles "\GIMP 2\bin\gimp-2.10.exe"
	static exception := "GIMP Startup"
	static toClose   := ""
	static closeWindow := "Quit GIMP " this.exeTitle

	static winObj := Win({
		winTitle:    this.winTitle,
		exePath:     this.path,
		toClose:     this.toClose,
		exception:   this.exception,
	})

	static Close() {
		this.winObj.Close()
		if !WinWait(this.closeWindow,, this.winObj.waitTime)
			return
		Send("{Left}{Enter}")
	}
}