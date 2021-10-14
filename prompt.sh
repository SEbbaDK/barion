#!/usr/bin/env bash

SHELL_PS1="\e[1;30;43m$([ -n "$IN_NIX_SHELL" ] && if [ -n "$name" ]; then echo " $name "; else echo ' nix-shell '; fi)\e[m"
USER_PS1="\e[1;30;41m $USER \e[m"
HOST_PS1="\e[1;30;45m $HOSTNAME \e[m"
PATH_PS1="\e[1;30;42m $(pwd | sed "s#$HOME#~#g") \e[m"
if command -v git &> /dev/null && [ -n "$(git rev-parse --is-inside-work-tree 2> /dev/null)" ]
then
  STATUS=$(git status --porcelain)
  ORIGIN=$(git remote | head -n 1)
  TAG=$(git describe --tag --exact-match 2>/dev/null)
  BRANCH=$(git branch --show-current)
  [ -z $BRANCH ] && BRANCH=$(git rev-parse HEAD | head -c 6)
  GIT_PS1="\e[1;30;44m $BRANCH "
  [ -n $TAG ] && GIT_PS1="$GIT_PS1$TAG";

  if [ "$STATUS" != "" ]
  then
      STAGED="$(echo "$STATUS" | grep '^[^ ?]' | wc -l)"
      [ "$STAGED" != 0 ] && GIT_PS1="$GIT_PS1$STAGED× "
      CHANGES="$(echo "$STATUS" | grep '^.M' | wc -l)"
      [ "$CHANGES" != 0 ] && GIT_PS1="$GIT_PS1$CHANGES¤ "
      UNTRACKED="$(echo "$STATUS" | grep '^.?' | wc -l)"
      [ "$UNTRACKED" != 0 ] && GIT_PS1="$GIT_PS1$UNTRACKED+ "
      DELETED="$(echo "$STATUS" | grep '^.D' | wc -l)"
      [ "$DELETED" != 0 ] && GIT_PS1="$GIT_PS1$DELETED- "
  fi

  if git branch -r | grep -q "$ORIGIN/$BRANCH"
  then
    AHEAD_BEHIND=$(git rev-list --left-right --count "$BRANCH...$ORIGIN/$BRANCH")
    AHEAD=$(echo "$AHEAD_BEHIND" | pcregrep -o1 "^([0-9]+)\t([0-9]+)")
    BEHIND=$(echo "$AHEAD_BEHIND" | pcregrep -o2 "^([0-9]+)\t([0-9]+)")
    GIT_PS1="$GIT_PS1$([ "$AHEAD" != 0 ] && echo "$AHEAD↑ ")"
    GIT_PS1="$GIT_PS1$([ "$BEHIND" != 0 ] && echo "$BEHIND↓ ")"
  else
    GIT_PS1="$GIT_PS1↟ "
  fi

  GIT_PS1="$GIT_PS1\e[m"
else
  GIT_PS1=""
fi
echo -e "$SHELL_PS1$USER_PS1$HOST_PS1$PATH_PS1$GIT_PS1"
PS1='\[\e[1m\]\$\[\e[m\] '

