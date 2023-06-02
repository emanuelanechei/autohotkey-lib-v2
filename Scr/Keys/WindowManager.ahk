#Include <Abstractions\Registers>
#Include <Utils\GetInput>
#Include <Abstractions\WindowManager>

#!Space:: {
	sValidKeys := Registers.ValidRegisters "[]\{}|-=_+;:'`",<.>/?"
	try key := Registers.ValidateKey(GetInput("L1", "{Esc}").Input, sValidKeys)
	catch UnsetItemError {
		Registers.CancelAction()
		return
	}

	static presets := Map(

		"h", () => WindowManager.Presets().LeftSide(),
		"l", () => WindowManager.Presets().RightSide(),
		"j", () => WindowManager.Presets().BottomSide(),
		"k", () => WindowManager.Presets().TopSide(),
		"[", () => WinRestore("A"),
		"]", () => WinMaximize("A"),
		".", () => Win.CloseOnceInactive(),
		"/", () => WinSetAlwaysOnTop(-1, "A"),

	)

	if key
		try presets[key].Call()
}
