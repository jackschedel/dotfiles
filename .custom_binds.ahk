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


; markdown code block paste
!V::
{
    Send "``````"
    Send "+{Enter}"
    Send "^{v}"
    Send "+{Enter}"
    Send "``````"
}

