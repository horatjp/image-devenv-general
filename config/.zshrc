setopt no_beep
setopt correct
setopt auto_cd
setopt interactive_comments

# alias
[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias

# history
[ -f ~/.zshrc.history ] && source ~/.zshrc.history

# Znap
[ -f ~/.zshrc.znap ] && source ~/.zshrc.znap

# starship
eval "$(starship init zsh)"

# gh completion
[ -n "$(which gh)" ] && eval "$(gh completion -s zsh)"

# mise
eval "$(mise activate zsh)"
eval "$(mise completion zsh)"
