#Include <Utils\Autoclicker>
#Include <Abstractions\Base>
#Include <Utils\Press>
#Include <Utils\Image>
#Include <App\Screenshot>
#Include <Tools\Hider>
#Include <Abstractions\Script>
#Include <Tools\Point>
#Include <Tools\HoverScreenshot>

#MaxThreadsBuffer true

XButton2 & XButton1::Escape
XButton1 & XButton2::Media_Play_Pause

XButton2 & WheelUp::Volume_Up
XButton2 & WheelDown::Volume_Down

XButton1 & WheelUp::Redo()
XButton1 & WheelDown::Undo()

XButton1 & LButton::Press.Hold_Sugar(Send.Bind("{BackSpace}"), SelectAll)
XButton1 & RButton::Delete

XButton2 & LButton::Screenshot.winObj.RunAct()
XButton2 & RButton::Enter

XButton2 & MButton::Screenshot.CaptureScreen()
XButton1 & MButton::HoverScreenshot().UseRecentScreenshot().Show()

+!LButton::AutoClicker()
#!LButton::Hider()
#LButton:: {
	While GetKeyState("LButton", "P")
		Point().Create()
}

#HotIf GetKeyState("Ctrl", "P")
Media_Stop & XButton1::Cut()
#HotIf

Media_Stop & XButton1::Copy()
Media_Stop & XButton2::Paste()

; Media_Stop & RButton::return
Media_Stop & MButton::F5
; Media_Stop & LButton::return

XButton1 & Media_Stop::Script.Test()
XButton2 & Media_Stop::Script.Reload()

#MaxThreadsBuffer false