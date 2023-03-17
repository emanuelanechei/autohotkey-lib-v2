#Include <Extensions\Gui>

class Infos {

    /**
     * To use Info, you just need to create an instance of it, no need to call any method after
     * @param text *String*
     * @param autoCloseTimeout *Integer* in milliseconds. Doesn't close automatically
     */
    __New(text, autoCloseTimeout := 0) {
        this.autoCloseTimeout := autoCloseTimeout
        this.text := text
        this._CreateGui()
        if !this._GetAvailableSpace() {
            this._StopDueToNoSpace()
            return
        }
        this._SetupHotkeysAndEvents()
        this._SetupAutoclose()
        this._Show()
    }


    static FontSize        := 20
    static Distance        := 3
    static unit            := A_ScreenDPI / 96
    static guiWidth        := Infos.FontSize * Infos.unit * Infos.Distance
    static maximumInfos    := Floor(A_ScreenHeight / Infos.guiWidth)
    static availablePlaces := Infos._GeneratePlacesArray()


    static _GeneratePlacesArray() {
        availablePlaces := []
        loop Infos.maximumInfos {
            availablePlaces.Push(false)
        }
        return availablePlaces
    }


    autoCloseTimeout := 0

    bfDestroy := this.Destroy.Bind(this)


    /**
     * Will replace the text in the Info
     * If the window is destoyed, just creates a new Info. Otherwise:
     * If the text is the same length, will just replace the text without recreating the gui.
     * If the text is of different length, will recreate the gui in the same place
     * (once again, only if the window is not destroyed)
     * @param newText *String*
     * @returns {Infos} the class object
     */
    ReplaceText(newText) {

        try WinExist(this.gInfo)
        catch
            return Infos(newText, this.autoCloseTimeout)

        if StrLen(newText) = StrLen(this.gcText.Text) {
            this.gcText.Text := newText
            this._SetupAutoclose()
            return this
        }

        Infos.availablePlaces[this.spaceIndex] := false
        return Infos(newText, this.autoCloseTimeout)
    }

    Destroy(*) {
        try HotIfWinExist("ahk_id " this.gInfo.Hwnd)
        catch Any {
            return false
        }
        Hotkey("Escape", "Off")
        this.gInfo.Destroy()
        Infos.availablePlaces[this.spaceIndex] := false
        return true
    }


    _CreateGui() {
        this.gInfo  := Gui("AlwaysOnTop -Caption +ToolWindow").DarkMode().MakeFontNicer(Infos.FontSize) ;.NeverFocusWindow()
        this.gcText := this.gInfo.AddText(, this.text)
    }

    _GetAvailableSpace() {
        spaceIndex := unset
        for index, isOccupied in Infos.availablePlaces {
            if isOccupied
                continue
            spaceIndex := index
            Infos.availablePlaces[spaceIndex] := this
            break
        }
        if !IsSet(spaceIndex)
            return false
        this.spaceIndex := spaceIndex
        return true
    }

    _CalculateYCoord() => Round(this.spaceIndex * Infos.guiWidth - Infos.guiWidth)

    _StopDueToNoSpace() => this.gInfo.Destroy()

    _SetupHotkeysAndEvents() {
        HotIfWinExist("ahk_id " this.gInfo.Hwnd)
        Hotkey("Escape", this.bfDestroy, "On")
        this.gcText.OnEvent("Click", this.bfDestroy)
        this.gInfo.OnEvent("Close", this.bfDestroy)
    }

    _SetupAutoclose() {
        if this.autoCloseTimeout {
            SetTimer(this.bfDestroy, -this.autoCloseTimeout)
        }
    }

    _Show() => this.gInfo.Show("AutoSize NA x0 y" this._CalculateYCoord())

}

Info(text, timeout?) => Infos(text, timeout ?? 2000)