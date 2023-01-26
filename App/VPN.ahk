#Include <Utils\Win>
#Include <Paths>

Class VPN {

	static process := "ExpressVPN.exe"
	static exeTitle := "ahk_exe " this.process
	static winTitle := "ExpressVPN " this.exeTitle
	static path := "C:\Program Files (x86)\ExpressVPN\expressvpn-ui\ExpressVPN.exe"

	static winObj := Win({
		winTitle: this.winTitle,
		exePath: this.path
	})
}