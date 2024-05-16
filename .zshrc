# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/snap/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH
export PATH=$PATH:$HOME/.local/lib/python3.11/site-packages
export PATH=$PATH:$HOME/.local/share/nvim/mason/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.2.0/bin
export PATH=$PATH:$HOME/.local/share/bob/nvim-bin


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export HOMEBREW_NO_ENV_HINTS=1

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN=~

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git per-directory-history)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi


source "$ZSH/passwordless-history.plugin.zsh"
export HISTORY_EXCLUDE_PATTERN="^ykchalresp*|$HISTORY_EXCLUDE_PATTERN"
export HISTORY_EXCLUDE_PATTERN="^cd*|$HISTORY_EXCLUDE_PATTERN"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

unzippable_types=("zip" "tar.gz" "tar.bz2" "tar.xz" "jar")

unzip_most_recent_here() {
  for type in "${unzippable_types[@]}"; do
    file=$(\ls -t /Users/jack/Downloads/*.$type 2> /dev/null | head -n1)
    if [[ -n "$file" ]]; then
      echo "Unzipping $file"
      case $type in
        "zip")
          unzip "$file" -d ./
          ;;
        "tar.gz")
          tar -zxvf "$file" -C ./
          ;;
        "tar.bz2")
          tar -jxvf "$file" -C ./
          ;;
        "tar.xz")
          tar -Jxvf "$file" -C ./
          ;;
        "jar")
          jar -xf "$file"
          ;;
      esac
      return
    fi
  done
  echo "No unzippable files found."
}

nvm_init() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}

unzip_most_recent_new_folder() {
  for type in "${unzippable_types[@]}"; do
    file=$(\ls -t /Users/jack/Downloads/*.$type 2> /dev/null | head -n1)
    if [[ -n "$file" ]]; then
      # Get the filename without extension
      filename=$(basename "$file" .$type)
      # Create a directory with the filename
      mkdir -p "$filename"
      echo "Unzipping $file to $filename"
      case $type in
        "zip")
          unzip "$file" -d "./$filename"
          ;;
        "tar.gz")
          tar -zxvf "$file" -C "./$filename"
          ;;
        "tar.bz2")
          tar -jxvf "$file" -C "./$filename"
          ;;
        "tar.xz")
          tar -Jxvf "$file" -C "./$filename"
          ;;
        "jar")
          # JAR files cannot be extracted to a specific directory
          # We change to the target directory before extraction
          cd "$filename"
          jar -xf "../$file"
          cd ..
          ;;
      esac
      return
    fi
  done
  echo "No unzippable files found."
}

move_most_recent() {
  file=$(\ls -t /Users/jack/Downloads/* 2> /dev/null | head -n1)
  if [[ -n "$file" ]]; then
    echo "Copying $file"
    cp $file ./
  else
    echo "No files found."
  fi
}


edit_most_recent() {
  file=$(\ls -t /Users/jack/Downloads/* 2> /dev/null | head -n1)
  if [[ -n "$file" ]]; then
    nvim $file
  else
    echo "No files found."
  fi
}

alias a='clear && fastfetch'
alias l='colorls --sd'
alias v='nvim'
alias f='open .'
alias t='tmux'
alias c='clear'
alias e='exit'
alias q='exit'
alias j='if [ -f package.json ]; then nvim package.json; else if [ -f ../package.json ]; then nvim ../package.json; else if [ -f ../../package.json ]; then nvim ../../package.json; else if [ -f ../../../package.json ]; then nvim ../../../package.json; else if [ -f ../../../../package.json ]; then nvim ../../../../package.json; else echo "No package.json found"; fi; fi; fi; fi; fi'
alias z="unzip_most_recent_new_folder"
alias m="move_most_recent"
alias n='nvm_init'

alias lg='lazygit'
alias en='nvim .env'
alias zh="unzip_most_recent_here"
alias vd="edit_most_recent"
alias la='colorls -Al --sd'
alias ls='colorls -A --sd'
alias ld='colorls -At --gs --sd'
alias lf='colorls -t --tree --sd'
alias nvr='nvr -s'
alias ase='open /Users/jack/reps/aseprite/build/bin/aseprite.app'

alias dev='pnpm run dev'
alias lint='pnpm run lint'
alias yarn='pnpm'
alias pret='pnpm prettier --write .'
alias studio='pnpm run db:studio'

alias fuck='sudo $(fc -ln -1)'

alias python='python3'
alias pip='pip3'

alias zshrc='nvim ~/.zshrc && source ~/.zshrc'
alias nvconf='nvim ~/.config/nvim/lua/'
alias sketch='cd ~/.config/sketchybar/ && nvim ./sketchybarrc'
alias ahk='nvim ~/.config/skhd/skhdrc && skhd --restart-service'
alias wez='nvim ~/.wezterm.lua'
alias tmuxrc='cd ~/.config/tmux/ && nvim ./tmux.conf'
alias yabairc='nvim ~/.config/yabai/yabairc && yabai --restart-service'

alias np='i=1; while [[ -e ~/.notepads/notepad$i.txt || -e ~/.local/state/nvim/swap//%tmp%notepad$i.txt.swp ]]; do ((i++)); if [ $i -gt 99999 ]; then echo "Cannot create new file. Cleanup ~/.notepads directory or nvim swap directory."; return 1; fi; done; nvim ~/.notepads/notepad$i.txt'

setopt aliases
setopt noautomenu
setopt nomenucomplete
setopt banghist

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(zoxide init zsh --cmd cd)"
