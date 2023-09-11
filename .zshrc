# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/snap/bin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
# DISABLE_AUTO_TITLE="true"

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
plugins=(git)

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

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias lg='lazygit'
alias fuck='sudo $(fc -ln -1)'
alias v='nvim'
alias zshrc='nvim ~/.zshrc && source ~/.zshrc'
alias nvconf='cd ~/.config/nvim/lua/ && nvim ./custom/mappings.lua'

alias pynp='i=1; while [[ -e /tmp/notepad$i.py || -e ~/.local/state/nvim/swap//%tmp%notepad$i.py.swp ]]; do ((i++)); if [ $i -gt 99999 ]; then echo "Cannot create new file. Cleanup /tmp directory or nvim swap directory."; return 1; fi; done; nvim /tmp/notepad$i.py'
alias cppnp='i=1; while [[ -e /tmp/notepad$i.cpp || -e ~/.local/state/nvim/swap//%tmp%notepad$i.cpp.swp ]]; do ((i++)); if [ $i -gt 99999 ]; then echo "Cannot create new file. Cleanup /tmp directory or nvim swap directory."; return 1; fi; done; nvim /tmp/notepad$i.cpp'
alias cnp='i=1; while [[ -e /tmp/notepad$i.c || -e ~/.local/state/nvim/swap//%tmp%notepad$i.c.swp ]]; do ((i++)); if [ $i -gt 99999 ]; then echo "Cannot create new file. Cleanup /tmp directory or nvim swap directory."; return 1; fi; done; nvim /tmp/notepad$i.c'
alias np='i=1; while [[ -e /tmp/notepad$i.txt || -e ~/.local/state/nvim/swap//%tmp%notepad$i.txt.swp ]]; do ((i++)); if [ $i -gt 99999 ]; then echo "Cannot create new file. Cleanup /tmp directory or nvim swap directory."; return 1; fi; done; nvim /tmp/notepad$i.txt'

alias c=clear
alias j='if [ -f package.json ]; then nvim package.json; else echo "No package.json found"; fi'
alias e='exit'

alias tiva='cd /mnt/c/ti/ccs1230/ccs/utils/tivaware_c_series_2_1_4_178/examples/boards/ek-tm4c123gxl'
alias microp='cd /mnt/c/Users/jacks/Documents/microp2-deps'

# To run on system restart to fix run-interpreter errors
alias wsl='sudo update-binfmts --disable cli'

alias l='colorls --sd'
alias la='colorls -Al --sd'
alias ls='colorls -A --sd'
alias ld='colorls -At --gs --sd'
alias lf='colorls -t --tree --sd'

setopt aliases
setopt noautomenu
setopt nomenucomplete
setopt banghist

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /home/jack/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
