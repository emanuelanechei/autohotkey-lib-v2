#Include <Extensions\Gui>

class Point {

    __New(x, y, size?, color?) {
        this.x := x
        this.y := y
        if IsSet(color)
            this.Color := color
        if IsSet(size)
            this.Size := size
    }


    Size {
        get => Point.unit * this.multiplier
        set => this.multiplier := value
    }


    Color := 0xDE4D37
    multiplier := 15
    guiExist := false


    static unit := A_ScreenDPI / 96


    Create() {
        if this.guiExist
            this.Destroy()
        this.guiObj := Gui("AlwaysOnTop -Caption +ToolWindow")
        this.guiObj.BackColor := this.Color
        this.guiExist := true
        this._Show()
    }

    Destroy() {
        if !this.guiExist
            return
        this.guiObj.Destroy()
        this.guiExist := false
    }


    _Show() {
        this.guiObj.Show(Format(
            "NA w{1} h{1} x{2} y{3}",
            Round(this.Size),
            this._CalculateGuiCoord(this.x),
            this._CalculateGuiCoord(this.y)
        ))
        this.guiObj.NeverFocusWindow()
        this.guiObj.MakeClickthrough()
    }

    _CalculateGuiCoord(coord) => Round(coord - this.Size / 2)

}