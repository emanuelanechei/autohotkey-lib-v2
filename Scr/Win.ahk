#Include <Utils\Win>
#Include <App\VPN>
#Include <Paths>
#Include <App\Telegram>
#Include <App\Discord>
#Include <App\Browser>
#Include <App\Autohotkey>
#Include <App\VsCode>
#Include <App\Terminal>
#Include <App\Spotify>

#MaxThreadsBuffer true

<!s::Spotify.winObj.App()
<!a::VsCode.winObj.App()
<!c::Browser.winObj.App()
<!q::Discord.winObj.App()
<!t::Telegram.winObj.App()
<!r::Terminal.winObj.App()
<!z::VPN.winObj.App()
!Pause::OBS.winObj.App()

#MaxThreadsBuffer false
