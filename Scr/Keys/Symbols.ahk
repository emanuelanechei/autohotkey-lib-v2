#Include <Utils\Char>
#Include <Abstractions\Registers>

#sc27:: {
    sValidKeys := Registers.ValidRegisters "[]\{}|-=_+;:'`",<.>/?"
    try key := Registers.ValidateKey(KeyChorder(), sValidKeys)
    catch UnsetItemError {
        Registers.CancelAction()
        return
    }
    static symbols := Map(

        "f", Symbol.Bind("fearful"),      ; 😨
        "d", Symbol.Bind("smiling imp"),  ; 😈
        "p", Symbol.Bind("purple heart"), ; 💜
        "r", Symbol.Bind("rolling eyes"), ; 🙄
        "h", Symbol.Bind("handshake"),    ; 🤝
        "s", Symbol.Bind("shrug"),        ; 🤷
        "n", Symbol.Bind("nerd"),         ; 🤓
        "a", Symbol.Bind("amogus"),       ; ඞ
        "[", Symbol.Bind("confetti"),     ; 🎉

    )
    if key
        try symbols[key].Call()
}

;🥺😋🤯😼😎😩🤤👉👈
#y::Symbol("pleading")
#u::Symbol("yum")
#i::Symbol("exploding head")
#o::Symbol("smirk cat")
#p::Symbol("sunglasses")
#sc1a::Symbol("weary")
#sc1b::Symbol("drooling")
#sc2b::Symbol(["finger right", "finger left"])
;😭🧐😳🤨🤔—💀
#6::Symbol("sob")
#7::Symbol("face with monocle")
#8::Symbol("flushed")
#9::Symbol("face with raised eyebrow")
#0::Symbol("thinking")
#-::Symbol("long dash", " ")
#=::Symbol("skull")