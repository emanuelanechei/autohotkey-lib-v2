#Include <Utils\ClipSend>
#Include <Loaders\Links>
#Include <Extensions\String>
#Include <Utils\Win>
#Include <Paths>
#Include <Utils\Char>
#Include <Abstractions\Script>
#Include <Converters\DateTime>
#Include <Tools\CleanInputBox>
#Include <App\Slack>
#Include <Misc\Meditate>

#j:: {
    if !input := CleanInputBox().WaitForInput() {
        return false
    }

    static runner_commands := Map(

        "m",     () => Meditate(20),
        "kb",    () => KeyCodeGetter(),
        "libs?", () => Infos(CountLibraries()),

        ;Apps
        "apps",    MainApps,
        "v1 docs", () => Autohotkey.Docs.v1.RunAct(),
        "davinci", () => Davinci.projectWinObj.RunAct(),
        "slack",   () => Slack.winObj.RunAct(),
        "fl",      () => FL.winObj.RunAct(),
        "gimp",    () => Gimp.winObj.RunAct(),

        ;Folders
        "ext",   () => Explorer.WinObj.VsCodeExtensions.RunAct_Folders(),
        "saved", () => Explorer.WinObj.SavedScreenshots.RunAct_Folders(),
        "main",  () => VsCode.WorkSpace("Main"),

    )

    try runner_commands[input].Call()
    catch Any {
        RegexMatch(input, "^(cp|glo|p|o|rap|t|fav|ev|i|show|link|ep|delow|gl|go|install|dd|down|drop|disc|evp) (.+)", &result)
        static runner_regex := Map(

            "cp", (input) => (
                A_Clipboard := input,
                Info('"' input '" copied')
            ),
            "glo", (input) => (
                link := Git.Link(input),
                Browser.RunLink(link),
                A_Clipboard := link
            ),
            "p",       (input) => ClipSend(Links[input], , false),
            "o",       (input) => Browser.RunLink(Links[input]),
            "rap",       (input) => Spotify.NewRapper(input),
            "fav",     (input) => Spotify.FavRapper_Manual(input),
            "ev",      (input) => Infos(Calculator(input)),
            "evp",     (input) => ClipSend(Calculator(input)),
            "i",       (input) => Infos(input),
            "show",    (input) => Shows().Run(input),
            "down",    (input) => Shows().Run(input, "downloaded"),
            "link",    (input) => Shows().SetLink(input),
            "ep",      (input) => Shows().SetEpisode(input),
            "delow",   (input) => Shows().DeleteShow(input),
            "dd",      (input) => Shows().SetDownloaded(input),
            "drop",    (input) => Shows().DeleteShow(input, true),
            "gl",      (input) => ClipSend(Git.Link(input),, false),
            "go",      (input) => Browser.RunLink(Git.Link(input)),
            "install", (input) => Git.InstallAhkLibrary(input),
            "disc",    (input) => Spotify.NewDiscovery_Manual(input),

        )
        try runner_regex[result[1]].Call(result[2])
    }
}
