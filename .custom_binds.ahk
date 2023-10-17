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


; tmux binds
!C::
{
  Send "^{b}"
  Send "c"
}
!1::
{
  Send "^{b}"
  Send "1"
}
!2::
{
  Send "^{b}"
  Send "2"
}
!3::
{
  Send "^{b}"
  Send "3"
}
!4::
{
  Send "^{b}"
  Send "4"
}
!5::
{
  Send "^{b}"
  Send "5"
}
!6::
{
  Send "^{b}"
  Send "6"
}
!7::
{
  Send "^{b}"
  Send "7"
}
!8::
{
  Send "^{b}"
  Send "8"
}
!9::
{
  Send "^{b}"
  Send "9"
}
!0::
{
  Send "^{b}"
  Send "0"
}
!+X::
{
  Send "^{b}"
  Send "x"
  Send "y"
}


!V::
{
  Send "``````"
  Send "+{Enter}"
  Send "^{v}"
  Send "+{Enter}"
  Send "``````"
  Send "+{Enter}"
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
