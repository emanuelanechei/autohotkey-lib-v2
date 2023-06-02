#Include <Utils\Press>
#Include <Utils\Win>
#Include <Abstractions\Base>
#Include <App\Youtube>
#Include <App\Spotify>
#Include <Abstractions\MediaActions>
#Include <Misc\CloseButActually>
#Include <Abstractions\WindowManager>

#MaxThreadsBuffer true

XButton2:: {
	sections := Press.GetSections()
	Switch {
		Case sections.topRight:    WindowManager.Maximize()
		Case sections.topLeft:     WindowManager.RestoreDown()
		Case sections.bottomRight: Send("{Browser_Forward}")
		Case sections.bottomLeft:  Send("{Browser_Back}")
		Case sections.down:        CloseButActually()
		Case sections.up:          Win.Minimize()
		Case sections.right:       MediaActions.SkipNext()
		Case sections.left:        MediaActions.SkipPrev()
		Default:                   return
	}
}

#MaxThreadsBuffer false