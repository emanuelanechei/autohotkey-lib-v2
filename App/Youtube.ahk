#Include <Utils\Image>
#Include <App\Browser>

Class Youtube {

    static winTitle := "YouTube " Browser.exeTitle

    static Studio := "YouTube Studio " Browser.exeTitle

    static NotWatchingVideo := "(?<! - )Watch later|Subscriptions|Youtube " Browser.exeTitle

    static SkipNext() => Send("+n")

    static SkipPrev() => Send("+p")

    static ChannelSwitch() {
        try Youtube.UIA.AccountElement.Click()
        try Youtube.UIA.SwitchAccountElement.Click()
    }

    static StudioSwitch() {
        try Youtube.UIA.AccountElement.Click()
        try Youtube.UIA.YoutubeStudioElement.Click()
    }

    static StudioChannelSwitch() {
        try Youtube.UIA.StudioAccountElement.Click()
        try Youtube.UIA.SwitchAccountElement.Click()
    }

    static ToYouTube() {
        try Youtube.UIA.StudioAccountElement.Click()
        try Youtube.UIA.ToYoutube.Click()
    }

    static Like() {
        try Youtube.UIA.LikeButtonElement.ToggleState := true
    }

    static ToggleShuffle() {
        try Youtube.UIA.ShuffleButton.Toggle()
    }

    static SaveToPlaylist() {
        try Youtube.UIA.MoreActionsButton.Click()
    }

    class UIA {

        static StudioSwitchAccountElement {
            get => Browser.UIA.Document.WaitElement({
                Type: "Link",
                Name: "Switch account",
                Order: 2
            })
        }

        static StudioToYoutubeElement {
            get => Browser.UIA.Document.WaitElement({
                Name: "YouTube",
                Type: "Link",
                Order: 2
            })
        }

        static StudioAccountFloatingMenuElement {
            get => Browser.UIA.Document.WaitElement({
                Type: 50025,
                Order: 2,
                Scope: 2,
                Index: -2
            })
        }

        static MainGroup {
            get => Browser.UIA.Document.FindElement({
                Type: "Group"
            }).FindElement({
                Type: "Group",
                Scope: 2
            })
        }

            static AccountFloatingMenuElement {
                get => Youtube.UIA.MainGroup.WaitElement({
                    Type: "Group",
                    Name: "Switch account",
                    Matchmode: "Substring",
                    Order: 2
                })
            }

                static YoutubeStudioElement {
                    get => Youtube.UIA.AccountFloatingMenuElement.WaitElement({
                        Type: "Link",
                        Name: "YouTube Studio",
                    })
                }

                static SwitchAccountElement {
                    get => Youtube.UIA.AccountFloatingMenuElement.WaitElement({
                        Name: "Switch account",
                        Type: "Link",
                    })
                }

                static ToYoutube {
                    get => Youtube.UIA.AccountFloatingMenuElement.WaitElement({
                        Type: "Link",
                        Name: "YouTube",
                    })
                }

            static MainElement {
                get => Youtube.UIA.MainGroup.FindElement({
                    LocalizedType: "main",
                    Scope: 2
                })
            }

                static MoreActionsButton {
                    get => Youtube.UIA.MainElement.FindElement({
                        Name: "More actions",
                        Type: "Button",
                        Scope: 2
                    })
                }

                static SidePlaylist {
                    get => Youtube.UIA.MainElement.FindElement({
                        ClassName: "header style-scope ytd-playlist-panel-renderer",
                        Type: "Group",
                    })
                }

                    static ShuffleButton {
                        get => Youtube.UIA.SidePlaylist.FindElement({
                            Name: "Shuffle playlist",
                            Order: 2
                        })
                    }

                static LikeButtonElement {
                    get => Youtube.UIA.MainElement.FindElement({
                        Type: "Group",
                        ClassName: "style-scope ytd-segmented-like-dislike-button-renderer",
                        Scope: 2
                    }).FindElement({
                        LocalizedType: "toggle button",
                        Scope: 2
                    })
                }

            static BannerElement {
                get => Youtube.UIA.MainGroup.FindElement({
                    LocalizedType: "banner",
                    Scope: 2
                })
            }

                static AccountElement {
                    get => Youtube.UIA.BannerElement.FindElement({
                        Type: "Button",
                        Name: "Account profile photo that opens list of alternate accounts",
                        AutomationId: "avatar-btn",
                        Order: 2
                    })
                }

            static HeaderElement {
                get => Youtube.UIA.MainGroup.FindElement({
                    LocalizedType: "header",
                    Scope: 2
                })
            }

                static StudioAccountElement {
                    get => Youtube.UIA.HeaderElement.FindElement({
                        Type: "Button",
                        Name: "Account",
                        Order: 2,
                    })
                }

            static PopUpMenu {
                get => Youtube.UIA.MainGroup.FindElement({
                    Type: "Group",
                    Scope: 2,
                    Order: 2,
                    Index: 2
                }).FindElement({
                    AutomationId: "items"
                })
            }

                static SaveToPlaylistButton {
                    get => Youtube.UIA.PopUpMenu.FindElement({
                        Name: "Save",
                        Scope: 2
                    })
                }

    }
}
