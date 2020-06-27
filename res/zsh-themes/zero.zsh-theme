# Tweaked Zero Theme; full credits goes to Sergio SA - qqwaszx

# uc -> user color
local uc='green'; [ $UID -eq 0 ] && uc='red'
PROMPT='[%{$fg[$uc]%}%n%{$reset_color%}@%m %{$fg[$uc]%}%c$(git_prompt_info)%{$reset_color%}]$ '

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[$uc]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
