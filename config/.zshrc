setopt no_beep
setopt correct
setopt auto_cd
setopt interactive_comments

# alias
[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias

# history
[ -f ~/.zshrc.history ] && source ~/.zshrc.history

# Oh My Zsh
[ -f ~/.zshrc.oh-my-zsh ] && source ~/.zshrc.oh-my-zsh

# starship
eval "$(starship init zsh)"

# gh completion
[ -n "$(which gh)" ] && eval "$(gh completion -s zsh)"

# mise
eval "$(mise activate zsh)"
