#Include <Abstractions\Script>

#InputLevel 6
#SuspendExempt true
#!y::scr_Suspend()
#!u::scr_Reload()
#!i::scr_Test()
#!o::scr_ExitTest()
#ScrollLock::SystemReboot()
#Pause::Run(Paths.Apps["Slide to shutdown"])
#SuspendExempt false
#InputLevel 5
