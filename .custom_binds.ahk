#Requires AutoHotkey v2.0
#SingleInstance

; capslock to delete
CapsLock::
{
   Send "{Delete}"
}
^CapsLock::
{
   Send "^{Delete}"
}
^+CapsLock::
{
   Send "^+{Delete}"
}

; Global launch notepad
!N::
{
   Run "C:\Users\jacks\AppData\Local\Microsoft\WindowsApps\wt.exe -p Notepad"
}

; 60% keyboard WASD navigation
!A::
{
   Send "{Home}"
}
!D::
{
   Send "{End}"
}
!W::
{
   Send "{PgUp}"
}
!S::
{
   Send "{PgDn}"
}


!,::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "c"
    Send "nvconf"
    Send "+{Enter}"
  }
}
!.::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "c"
    Send "zshrc"
    Send "+{Enter}"
  }
}
!/::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "c"
    Send "binds"
    Send "+{Enter}"
  }
}
; tmux binds
!C::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "c"
  }
}
!+X::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "x"
    Send "y"
  }
}
!+R::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    ; replace current tab with fresh tab
    Send "^{b}"
    Send "c"

    Send "^{b}"
    Send "b"

    Send "^{b}"
    Send "x"
    Send "y"
  }
}

!1::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "1"
  }
}
!2::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "2"
  }
}
!3::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "3"
  }
}
!4::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "4"
  }
}
!5::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "5"
  }
}
!6::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "6"
  }
}
!7::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "7"
  }
}
!8::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "8"
  }
}
!9::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "9"
  }
}
!0::
{
  If (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    Send "^{b}"
    Send "0"
  }

}

!V::
{
; Markdown code-block paste
   If (WinActive("ahk_exe KoalaClient.exe") or WinActive("ahk_exe Discord.exe")or WinActive("ahk_exe Teams.exe"))
   {
    Send "``````"
    Send "+{Enter}"

    If( WinActive("ahk_exe Teams.exe"))
    {
      Sleep 3
    }
    Send "^{v}"
    Send "+{Enter}"
    Send "``````"
    Send "+{Enter}"
   }
}


; Win w+d fancyzones remap
#W::
{
   Send "#{PgUp}"
}
#S::
{
   Send "#{PgDn}"
}
