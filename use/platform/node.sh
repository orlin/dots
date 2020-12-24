# NOTE: sourced from elsewhere
# use/aliases/npm.sh
# src/node.sh (sometimes)

holy-dot src/ install os

if holy-be-on platform/node; then

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

  if onLinux; then
    [ -s "$NVM_DIR"/nvm.sh ] && . "$NVM_DIR"/nvm.sh
  elif onMac; then
    . "$(brew --prefix nvm)"/nvm.sh
  fi

  # silently use /home/orlin/.nvmrc (this will pick up a change)
  nvm use > /dev/null

  # https://github.com/yarnpkg/yarn/issues/5353
  # after the nvm / npm global packages
  [ -x "$(command -v yarn)" ] && PATH-add "$(yarn global bin)"

fi
