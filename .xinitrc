#export GTK2_RC_FILES="~/.gtkrc-2.0:$GTK2_RC_FILES"
export LANG=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
export FIREFOX_DSP="aoss"
# source ~/dotrc/.xprofile.fcitx
source ~/dotrc/.xprofile.gcin
# source ~/dotrc/.xprofile.uim

exec xrdb ~/.Xresources&

# http://forums.gentoo.org/viewtopic-t-717117-highlight-firefox.html
#exec $HOME/.pack_ffox.sh&
exec urxvtd&
#(sleep 5;exec urxvt -geometry 96x54+0+18 )&

#xmodmap -e "keycode 131 = Super_L" -e "add mod4 = Super_L"
#xmodmap -e "keycode 129 = Super_L" -e "add mod4 = Super_L"
# Num_Lock
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=464041
xmodmap -e "keycode 77 = Num_Lock"
xmodmap -e "keycode 100 = Super_L" -e "add mod4 = Super_L"
xmodmap -e "keycode 102 = Super_L" -e "add mod4 = Super_L"
xmodmap -e "keycode 156 = XF86LaunchA"

#exec startxfce4

#DEFAULT_SESSION=awesome
DEFAULT_SESSION=echinus
#DEFAULT_SESSION=startxfce4
#DEFAULT_SESSION=gnome

case $1 in
kde)
	exec startkde
	;;
xfce4)
	exec startxfce4
	;;
fluxbox)
	exec fluxbox
	;;
gnome)
	exec gnome-session
	;;
pekwm)
	exec pekwm
	;;
#echinus)
awesome)
	exec conky -d&
	exec xfce4-panel&
	eval `cat $HOME/.fehbg`
	exec awesome
	#exec /usr/local/bin/scrotwm
	#exec /usr/bin/musca
	;;
xmonad)
	exec xfce4-panel&
  # exec xfdesktop&
  xsetroot -cursor_name left_ptr
	eval `cat $HOME/.fehbg`&
	# (sleep 2;exec /usr/local/bin/ourico;)&
	# (sleep 10;exec conky -d &)&
	#exec stalonetray&
	yeahconsole&
	(sleep 5;gcin& )&
	exec /usr/bin/xmonad
	;;
wmii)
  exec wmii
  ;;
*)
	exec xfce4-panel&
	eval `cat $HOME/.fehbg`&
	# (sleep 2;exec /usr/local/bin/ourico;)&
	# (sleep 10;exec conky -d &)&
	#exec stalonetray&
	(sleep 5;yeahconsole )&
	(sleep 5;gcin& )&
	exec /usr/bin/echinus
	;;

esac
