#exports


PATH="$PATH:/sbin:/usr/sbin:/home/gogonkt/scripts:/home/gogonkt/bin/reva/bin:/home/gogonkt/.ies4linux/bin/:/usr/local/bin:./"
export LD_LIBRARY_PATH=~/bin/reva/bin
PAGER='less'
LESS=-FXRS
EDITOR='vim'
AWT_TOOLKIT='MToolkit java -jar weka.jar'
export XDG_DATA_HOME=/home/gogonkt/.config/
export XDG_CONFIG_HOME=/home/gogonkt/.config/
export GREP_OPTIONS='--color=auto' GREP_COLOR='100;9'

#TERM environment variable to xterm-256color. 
set TERM xterm-256color; export TERM
TERM=xterm-256color

## completion
#自动补全功能 {{{
setopt AUTO_LIST
setopt AUTO_MENU
#开启此选项，补全时会直接选中菜单项
#setopt MENU_COMPLETE

autoload -U compinit
compinit

#自动补全缓存
zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd

#自动补全选项
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'

zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

#彩色补全菜单 
eval $(dircolors -b) 
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#错误校正      
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

#kill 命令补全      
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

#补全类型提示分组 
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}


# color module
autoload colors ; colors

# correction
#setopt correctall

# prompt {{{2
 autoload -U promptinit
 promptinit
# prompt gentoo

# prompt with git {{{3
# http://kriener.org/articles/2009/06/04/zsh-prompt-magic
setopt prompt_subst
autoload colors    
colors             

autoload -Uz vcs_info

# set some colors
for COLOR in RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'         
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done                                                 
PR_RESET="%{${reset_color}%}";                       

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
FMT_BRANCH="${PR_BRIGHT_GREEN}%b%u%c${PR_RESET}" # e.g. master¹²
FMT_ACTION="(${PR_CYAN}%a${PR_RESET}%)"   # e.g. (rebase-i)
FMT_PATH="%R${PR_YELLOW}/%S"              # e.g. ~/repo/subdir

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories    
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}//" "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}//"              "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""                             "%~"         

function precmd {       
    vcs_info 'prompt'          
}                              

function lprompt {
    local brackets=$1
    local color1=$2  
    local color2=$3  
                     
    local bracket_open="${color1}${brackets[1]}${PR_RESET}"
    local bracket_close="${color1}${brackets[2]}"          
                                                             
    local git='$vcs_info_msg_0_'                           
    local cwd="${color2}%B%1~%b"

    PROMPT="${PR_RESET}${bracket_open}${git}${cwd}${bracket_close}%# ${PR_RESET}"
}                                                                                        

function rprompt {
    local brackets=$1
    local color1=$2  
    local color2=$3  
                     
    local bracket_open="${color1}${brackets[1]}${PR_RESET}"
    local bracket_close="${color1}${brackets[2]}${PR_RESET}"
    local colon="${color1}:"                                
    local at="${color1}@${PR_RESET}"                        
                                                            
    local user_host="${color2}%n${at}${color2}%m"                    
    local vcs_cwd='${${vcs_info_msg_1_%%.}/$HOME/~}'        
    local cwd="${color2}%B%20<..<${vcs_cwd}%<<%b"
    local inner="${user_host}${colon}${cwd}"

    RPROMPT="${PR_RESET}${bracket_open}${inner}${bracket_close}${PR_RESET}"
}

lprompt '[]' $BR_BRIGHT_BLACK $PR_GREEN
rprompt '()' $BR_BRIGHT_BLACK $PR_GREEN

# }}}

# }}}

# zmv "programmable rename"
 autoload -U zmv
# # Replace spaces in filenames with a underline
# zmv '* *' '$f:gs/ /_'
# zmv '(* *)' '${1// /}'
# zmv -Q "(**/)(* *)(D)" "\$1\${2// /_}"
# # Change the suffix from *.sh to *.pl
# zmv -W '*.sh' '*.pl'
# # lowercase/uppercase all files/directories
# $ zmv '(*)' '${(L)1}' # lowercase
# $ zmv '(*)' '${(U)1}' # uppercase


#history
export HISTSIZE=5000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history

setopt autocd
setopt extendedglob
setopt share_history
#}}}


# Aliases and functions {{{1

# Allow for use of =command to test for commands below, w/o error messages. 
setopt nomatch
 
alias df='df -h'
alias free='free -m'
alias cls=clear
# Do we have GNU ls of a new enough version for color?
(ls --help 2>/dev/null |grep -- --color=) >/dev/null && \
        #alias ls='ls -CF --color=auto --group-directories-first'
        alias ls='ls -b --color=auto --group-directories-first'
alias l='ls'
alias ll='ls -lh'
#alias wget='LANG=C wget -c'
alias flv='mplayer $(ls -t /tmp/Flash*|head -1) -vo xv'
alias la='ls -da '
#alias ld='ls -ld *(-/DN)'
alias du='du -h'
alias dus='du -hs'
alias f=finger
alias edit=$EDITOR
alias e=$EDITOR
alias md=mkdir

alias j="jobs"                   # show all jobs
alias ..="cd .."                 # save 3 keystrokes...
alias diff="colordiff"           # pretty colors...
alias p="pwd"                    # more lazyness...
alias c="clear"                  # another quickie
alias untar="tar xzfv"           # for tarballs
alias unbz2="tar xvfj"           # for .bz2 archives
alias killff="killall firefox-bin" # a grim necessity
alias grep='grep --color=auto'   # color grep
alias more="less"
alias nano="nano -w"
# alias vim="vim -X"
alias man='LANG=en_US.UTF-8 man'

#alias cp='cp -i'                # Became too annoying for large copy/delete actions
##alias rm='rm -i'
alias mv='mv -i'
alias mkdir='mkdir -p'                # Creates parent directories automatically

# Put alive hosts at the bottom.
alias ruptime='ruptime -rt'
alias rd=rmdir
alias k=killall
alias mtr='mtr --curses'
#[[ -x =reportbug ]] && alias bug='reportbug -b --no-check-available -x -M --mode=expert'
alias slrn='slrn -n'
alias menu=pdmenu
alias xchat='xchat -C'
alias stardate='date "+%y%m.%d/%H%M"'
#if [[ -x =ytalk ]]; then
#	alias ytalk='ytalk -x'
#	alias talk=ytalk
#fi

# I don't like the zsh builtin time command.
#[[ -x =time ]] && alias time='command time'
#alias dch="dch -p -D UNRELEASED"
alias bc='bc -l -q'
#alias ytalk='ytalk -x'

# Calculator
calc () { echo $* |bc -l }
cgrep () { grep -r -w -B1 -A4 -i $* * } # code grep
scpshare  () { scp $*  gogonkt@www.linuxfire.com.cn:~/pub/share/ }
pe () { echo $* | perl -MURI::Escape -ne 'print uri_unescape($_)'}
tw () { curl -u gnkt: -d status=$* http://twitter.com/statuses/update.xml }
ocast () {
  cd /tmp/;
  lynx -dump 'http://usmirror.ourradio.hk/web/' \
  | egrep -io 'http.*:(jiu|ourradiomys|occultus|broad-band|gotocn&|wingchun|jpdrama|rosa|space|blue|72|meow|meoow|club|kingfu|film|anime|115).*' \
  |xargs lynx -dump \
  | grep --color=auto -io 'http.*ourradio.hk.*mp3' \
  | sed -e 's#web/../##g' \
  | LANG=C xargs -I{} curl -O -L -o "/tmp/%1" {};
  cd -;
  # | sed -e 's#download/index.php/url=##g' \
  # | LANG=C xargs wget -c -P/tmp/;
  }
mcast () {
  cd /tmp/;
  proxychains lynx -dump 'http://mobile.hkreporter.com/new.php' \
  |egrep -io 'http.*(hill|sea|special|siu|tam|wym).*mp3' \
  |LANG=C xargs proxychains wget -c -P/tmp;
  cd -;
  }

# alias for daily use
alias gm="ssh -C gmwx.3322.org"
alias i="ssh -C gmwx.3322.org -t 'LANG=zh_CN.utf8;screen -RD gogonkt'"
alias firefs="sshfs gogonkt@www.linuxfire.com.cn: firefs"
alias unfirefs="fusermount -u firefs"
alias mvllfs="sshfs mvll@ssh.alwaysdata.com: mvllfs"
alias unmvllfs="fusermount -u mvllfs"
alias s="screen -RD gogonkt"
alias screen='LANG=en_US.UTF-8 screen'
#alias sch="sc -RD ssh -c /etc/screenrc sh -c 'ssh -4NCxD 7070 oahong@199.71.214.60'"
alias sch="sc -RD ssh -c /etc/screenrc sh -c 'autossh -M 2000 -4NCxD 7070 oahong@ssh101.blockcn.com'"
alias ir='sc -RD irssi -c /etc/screenrc irssi'
alias xsu="sc -t ssu sh -e 'sudo su'"
alias sc="LANG=en_US.UTF-8 screen"                 # Starts screen
alias sr="LANG=en_US.UTF-8 screen -r"             # Screen Reattach
alias sd="LANG=en_US.UTF-8 screen -d"                 # Screen Detach
alias m="wine ~/share/MultiBank\ Trader\ CN/terminal.exe 2>/dev/null&"
alias q="wine ~/.wine/drive_c/QQ/QQ.exe 2>/dev/null&"
alias ie="wine ~/.wine/drive_c/Program\ Files/Internet\ Explorer/iexplore.exe&"
alias f="/opt/firefox/firefox-bin -P Forex -no-remote&"
alias vzsh="vi ~/.zshrc;source ~/.zshrc"
alias vawe="vi ~/.config/awesome/rc.lua"
# alias pdf="acroread"
alias pdf="mupdf"
alias ssu="sudo su -"
alias x="startx"
alias poeon="sudo pppoe-start"
alias xp="VBoxManage startvm xp-deep"
alias esleep="sudo hibernate-ram"
alias beeps="repeat 5 do aplay -q ~/share/MultiBank\ Trader\ CN/sounds/alert.wav;sleep 2; done"
alias 15sleep="( sleep $((60 * 15));repeat 5 do aplay -q ~/share/MultiBank\ Trader\ CN/sounds/alert.wav;sleep 2; done)"
alias 2hsleep="( sleep $((60 * 120));repeat 5 do aplay -q ~/share/MultiBank\ Trader\ CN/sounds/alert.wav;sleep 2; done)"
alias x="AWT_TOOLKIT=MToolkit ~/PersonalBrain/PersonalBrain"
alias mw='mplayer -aspect 16:9 '
alias mp='mplayer '
alias epv='emerge -pv '
# alias e='eix '
alias S='packer --noedit -S'
alias Si='packer -Si'
alias Ss='packer -Ss'
alias Syu='packer -Syu'
alias pR='pacman -R'
alias Ql='pacman -Ql'
alias Q='pacman -Q'
alias getip='curl -s http://checkip.dyndns.org/ | grep -o "[[:digit:].]\+" '
alias getcomfu='curl "http://www.commandlinefu.com/commands/browse/sort-by-votes/plaintext/[0-2500:25]" | grep -v _curl_ > comfu.txt'
alias .G="git --work-tree=$HOME/ --git-dir=$HOME/dotfiles.git"
alias rc.conf='sudo vim /etc/rc.conf'
alias zshrc='vim ~/.zshrc;source ~/.zshrc'

# Inline aliases, zsh -g aliases can be anywhere in command line
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g CA="2>&1 | cat -A"
alias -g C='| wc -l'
alias -g D="DISPLAY=:0.0"
alias -g DN=/dev/null
alias -g ED="export DISPLAY=:0.0"
alias -g F=' | fmt -'
alias -g G='| egrep --color=auto'
alias -g H='| head'
alias -g HL='|& head -20'
alias -g Sk="*~(*.bz2|*.gz|*.tgz|*.zip|*.z)"
alias -g LL="2>&1 | less"
alias -g L="| less"
alias -g LS='| less -S'
alias -g RNS='| sort -nr'
# alias -g S='| sort'
alias -g TL='| tail -20'
alias -g T='| tail'
alias -g HLP='--help'
alias -g TF='| tailf'
alias -g US='| sort -u'
alias -g X='| xargs'
alias -g ND='$(ls -d *(/om[1]))' # newest directory
alias -g NF='$(ls *(.om[1]))'    # newest file
alias -g MLD='/media/wine/emulebt/mldonkey/files'


alias -s rmvb=/usr/bin/mplayer
alias -s mkv=/usr/bin/mplayer
alias -s avi=/usr/bin/mplayer
alias -s mp3=/usr/bin/mplayer

#}}}

# Misc {{{1

# Force emacs editing mode.
bindkey -e
#[[ $TERM == "xterm" ]] && bindkey -e

# ctrl-s will no longer freeze the terminal.
#stty -ixon kill ^K
stty erase "^?"
#}}}


# Turn on full-featured completion (needs 2.1) {{{2
if [[ "$ZSH_VERSION" == (3.1|4)* ]]; then
	autoload -U compinit
	compinit
	if [[ -e ~/.ssh/known_hosts ]]; then
		# Use .ssh/known_hosts for hostnames.
		hosts=(${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*})
		zstyle ':completion:*:hosts' hosts $hosts 
	fi
fi
#}}}


# Key bindings {{{1

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

#bindkey '^K' kill-whole-line
#bindkey -s '^L' "|less\n"		# ctrl-L pipes to less
bindkey -s '^L' "| ~/scripts/vimless\n"		# ctrl-L pipes to less
bindkey -s '^B' " &\n"			# ctrl-B runs it in the background
bindkey "\e[1~" beginning-of-line	# Home (console)
bindkey "\e[H" beginning-of-line	# Home (xterm)
bindkey "\e[4~" end-of-line		# End (console)
bindkey "\e[F" end-of-line		# End (xterm)
bindkey "\e[2~" overwrite-mode		# Ins
bindkey "\e[3~" delete-char		# Delete
#}}}

# Moc controller {{{
ICONPATH=$HOME/.dzen
 
get_now_playing() {
        local state
        local music
        local ptime
 
        state=$(/usr/bin/mocp -i | sed -ne 's/^State: //p')
        case $state in
                PLAY)
                        music=$(/usr/bin/mocp -i | sed -ne 's/^Title: \(.*\)$/\1/p');
                        [ -z $music ] && music=$(/usr/bin/mocp -i | sed -ne 's/File: .*\/\([^ .].*\)$/\1/p')
                        ptime=$(/usr/bin/mocp -i | sed -ne 's/^TimeLeft: //p')
                        print "^fg(grey70)^i(${ICONPATH}/mpd.xbm)^fg(grey50) (-${ptime}^fg(#803A38)^p(3)^i(${ICONPATH}/play.xbm)^fg(grey50))^fg(grey85) ${music}^fg()"
                        ;;
                PAUSE)
                        music=$(/usr/bin/mocp -i | sed -ne 's/^Title: \(.*\)$/\1/p');
                        [ -z $music ] && music=$(/usr/bin/mocp -i | sed -ne 's/File: .*\/\([^ .].*\)$/\1/p')
                        ptime=$(/usr/bin/mocp -i | sed -ne 's/^CurrentTime: //p')
                        print "^fg(grey40)^i(${ICONPATH}/mpd.xbm)^fg(grey60) (${ptime}^fg(#803A38)^p(3)^i(${ICONPATH}/pause.xbm)^fg(grey60)) ${music}^fg()"
                        ;;
                STOP)
                        print "^fg(grey40)^i(${ICONPATH}/mpd.xbm)^fg(grey60) (^fg(#803A38)^p(2)^r(7x7)^p(2)^fg(grey60))"
                        ;;
        esac
 
}
#}}}

day() {
	(echo Today; cal; sleep 20) | dzen2 -x 200 -y 200 -w 155 -bg blue -l 8
  }
cpuinfo() {
	gcpubar -fg '#aecf96' -bg gray40 -h 7 -w 75 | dzen2 -ta l -w 150 -bg '#000000' -fg 'grey70' -e '' -x 400
  }
mocstatus() {
	while true; do get_now_playing;sleep 30;done |dzen2 -p -x 550 -w 250
  }
sleeps() {
	sleep $((60 * 30));repeat 5 do aplay -q ~/share/MultiBank\ Trader\ CN/sounds/alert.wav;sleep 2; done
  }
works() {
	sleep $((60 * 60 * 4));repeat 5 do aplay -q ~/share/MultiBank\ Trader\ CN/sounds/alert.wav;sleep 2; done
  }

. ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
