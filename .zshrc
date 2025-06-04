# ---
# The following command is to avoid freeze the terminal [1]
#
# References:
# 	[1] https://unix.stackexchange.com/questions/12107/how-to-unfreeze-after-accidentally-pressing-ctrl-s-in-a-terminal
# ---
stty ixany
stty ixoff -ixon
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

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

# ---
# Plugins
# ---
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git docker tmux)
#
# The plugins are installes using zgenom plugin manager.
# To install most of these plugins add zgenom load githubuser/reponame to .zshrc
source "${HOME}/.zgenom/zgenom.zsh"

# Check for plugin and zgenom updates every 7 days
# This does not increase the startup time.
zgenom autoupdate

# if the init script doesn't exist
if ! zgenom saved; then
    echo "Creating a zgenom save"

		zgenom load zsh-users/zsh-autosuggestions
		zgenom load zsh-users/zsh-syntax-highlighting

		zgenom save

EOPLUGINS
    # ^ can't indent this EOPLUGINS

    # add binaries
    zgenom bin tj/git-extras

    # completions
    zgenom load zsh-users/zsh-completions
		zgenom load softmoth/zsh-vim-mode

		# save all to init script
    zgenom save

    # Compile your zsh files
    zgenom compile "$HOME/.zshrc"
fi

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
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

# ---
# Detects the OS
#
# References:
# 	[1] https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
# ---

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# ---
# Path
# ---
if [[ ${unameOut} == "Linux" ]]; then
	export PATH="$PATH:/opt/nvim-linux64/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin"
elif [[ ${unameOut} == "Darwin" ]]; then
	export PATH=/opt/homebrew/bin:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/usr/local/MacGPG2/bin:/Applications/VMware:/Users/hsteinshiromoto/.local/bin:$HOME/.local/state/nix/profiles/profile/bin:/run/current-system/sw/bin
fi

export PATH="$PATH:/nix/var/nix/profiles/default/bin:$HOME/.tmux/plugins/tpm"
#
# ---
# Configuration: tmux
#
# References:
# 	[1] https://github.com/ohmyzsh/ohmyzsh/blob/fff073b55defed72a0a1aac4e853b165f208735b/plugins/tmux/tmux.plugin.zsh#L8
# ---
if [[ ${unameOut} == "Linux" ]]; then
	# Automatically start tmux when zsh is started [1]
	ZSH_TMUX_AUTOSTART=true
	#
	# Starts tmux with zsh [1]
	if [ "$TMUX" = "" ]; then tmux attach || tmux; fi
fi
# ---
# Configuration: bat
#
# References:
# 	[1] https://github.com/sharkdp/bat?tab=readme-ov-file#customization
# ---
export BAT_THEME="gruvbox-dark"

# ---
# Tab complete
# ---
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)							# Include hidden files

# ---
# Vi mode
# ---
bindkey -v
export KEYTIMEOUT=1

# ---
# Custom Functions
# ---

# FZF History
#
# References:
# 	[1] https://armno.medium.com/til-using-fzf-to-search-in-command-history-bf6c3ecc465e
hf() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# FZF git diff
#
# References:
# 	[1] https://medium.com/@GroundControl/better-git-diffs-with-fzf-89083739a9cb
gd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

# Yazi
#
# References:
# 	[1] https://yazi-rs.github.io/docs/quick-start
function yz() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
# ---
# Configuration: aliases
# ---
# References for fzf with bat preview ([1] is the one adopted here):
# 	[1] https://medium.com/@GroundControl/better-git-diffs-with-fzf-89083739a9cb
# 	[2] https://sidneyliebrand.medium.com/how-fzf-and-ripgrep-improved-my-workflow-61c7ca212861
alias rf="fzf --preview 'bat {-1} --color=always'"
alias cd="z"
alias ls="eza --hyperlink -alh --icons=auto --git"
alias ld="lazydocker"
alias lg="lazygit"
if [[ ${unameOut} == "Linux" ]]; then
	alias cat="bat"
elif [[ ${unameOut} == "Darwin" ]]; then
	alias cat="bat"
	alias ns="darwin-rebuild build --flake ~/.config/nix-darwin"
fi

# Docker aliases
alias dpl='docker pull'
alias dph='docker push'
alias dk='docker kill $(docker ps -a | fzf | awk "{ print $1 }")'
alias drm='docker rm $(docker ps -a | fzf | awk "{ print $1 }")'
alias ds='docker stop $(docker ps -a | fzf | awk "{ print $1 }")'
alias drmi='docker rmi $(docker images | fzf | awk "{print $3}")'

# The following fzf command should be kept below the cat alias


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---
# Configuration: Pyenv
# ---
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ---
# Configuration: zoxide
#
# Currently raising bugs
# Fix using the comment from G. Frx
# https://stackoverflow.com/questions/36668910/how-do-i-reload-zsh-config-files-without-replacing-the-current-shell
# ---
# eval "$(zoxide init --cmd cd zsh)"
#

# ---
# Configuratino: NeoVIm
# ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR=nvim
export VISUAL=nvim

# ---
# Secrets
#
# Dependencies:
# 	[D1] pass: https://www.passwordstore.org/, https://search.nixos.org/packages?channel=24.11&show=pass&from=0&size=50&sort=relevance&type=packages&query=pass
#
# References:
# 	[1] https://medium.com/@hitechluddite/ditch-cleartext-secrets-how-to-safeguard-api-keys-in-zsh-and-bash-with-pass-77f694b9ff64
# ---
export ANTHROPIC_API_KEY=$(pass show ANTHROPIC_API_KEY)

# ---
# FZF history
# ---
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
