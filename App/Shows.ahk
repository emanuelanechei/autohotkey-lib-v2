#Include <Utils\Choose>
#Include <App\Git>
#Include <Extensions\Json>
#Include <Abstractions\Text>
#Include <Paths>
#Include <Tools\Info>
#Include <Utils\Win>
#Include <App\Browser>
#Include <Extensions\String>
#Include <Converters\DateTime>

Class Shows {
    __New() {
        this.shows := JSON.parse(ReadFile(Paths.Ptf["Shows"]))
    }

    ApplyJson() => WriteFile(Paths.Ptf["Shows"], JSON.stringify(this.shows))

    CreateBlankShow(show) => this.shows.Set(show, Map("episode", 0, "link", "", "downloaded", 0, "timestamp", DateTime.Date " " DateTime.Time))

    ValidateShow(show) {
        try this.shows[show]
        catch Any {
            return false ;There for sure won't be a link nor an episode if the object doesn't exist yet, because if I either set the link or the episode, the show object will exist along with the properties, even if one of them doesn't have a non-zero value
        }
        return true
    }

    ValidateShowLink(show) {
        if !this.ValidateShow(show) {
            return false
        }
        if !this.shows[show]["link"] {
            Info("No link!🔗")
            return false ;If the object exists, so does the link property, which will be blank if I only set the episode (somehow). The episode always starts out being 0 though, no need to check for it
        }
        return true
    }

    GetLink(show, progressType := "episode") {
        if !this.ValidateShowLink(show) {
            return ""
        }
        return this.shows[show]["link"] this.shows[show][progressType] + 1
    }

    GetShows() {
        shows := []
        for key, _ in this.shows {
            shows.Push(key)
        }
        return shows
    }

    Run(show, progressType?) {
        try Run(this.GetLink(show, progressType?))
        catch Any {
            Info("Fucked up link :(")
            return
        }
        Browser.winObj.Activate()
    }

    DeleteShow(show?, isDropped := false) {
        if !IsSet(show) {
            if !show := Choose(this.GetShows()*)
                return
        }
        try {
            this.shows.Delete(show)
            this.ApplyJson()
        }
        this._UpdateConsumed(show, isDropped)
        this._PushConsumed(show, isDropped)
    }

    ValidateSetInput(input, regex) {
        input := CompressSpaces(input)

        RegexMatch(input, regex, &match)
        if !match {
            Info("Wrong!")
            return false
        }
        return match
    }

    SetLink(show_and_link) {
        if !show_and_link := this.ValidateSetInput(show_and_link, "(.+) (https:\/\/[^ ]+)") {
            return false
        }

        show := show_and_link[1]
        link := show_and_link[2]

        if !this.ValidateShow(show) {
            this.CreateBlankShow(show)
        }
        this.shows[show]["link"] := link

        this.ApplyJson()
        Info(show ": link set")
    }

    SetEpisode(episode) {
        if !episode := this.ValidateSetInput(episode, "\d+")[] {
            Infos("exited")
            return false
        }

        if !show := Choose(this.GetShows()*)
            return
        this.shows[show]["episode"] := episode
        this.shows[show]["timestamp"] := DateTime.Date " " DateTime.Time

        if episode > this.shows[show]["downloaded"] {
            this.shows[show]["downloaded"] := episode
        }

        this.ApplyJson()
        Info(show ": " episode)
        Git(Paths.Shows).Add(Paths.Ptf["Shows"]).Commit("watch episode " episode " of show " show).Push().Execute()
        Info("pushed!")
    }

    SetDownloaded(downloaded) {
        if !downloaded := this.ValidateSetInput(downloaded, "\d+")[] {
            return false
        }

        if !show := Choose(this.GetShows()*)
            return
        this.shows[show]["downloaded"] := downloaded

        this.ApplyJson()
        Info(show ": " downloaded)
        Git(Paths.Shows).Add(Paths.Ptf["Shows"]).Commit("download episode " downloaded " of show " show).Push().Execute()
        Info("pushed!")
    }


    _UpdateConsumed(show, isDropped := false) {
        date := "`n1. " DateTime.Date " - "
        isDropped_string := isDropped ? " - dropped" : ""
        AppendFile(Paths.Ptf["Consumed"], date show.ToTitle() isDropped_string)
    }

    _PushConsumed(show, isDropped := false) {
        action := isDropped ? "drop" : "finish"
        Info(action " " show)
        Git(Paths.Shows).Add(Paths.Ptf["Consumed"], Paths.Ptf["Shows"]).Commit(action " " show).Push().Execute()
        Info("pushed!")
    }
}