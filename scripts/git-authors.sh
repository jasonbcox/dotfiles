#!/bin/sh
# git authors [git-log args] — commits and lines added/removed per author.
#
#   264  +155412/-68567 Δ +86845  Some Author <some@example.com>
#
# Accepts anything `git log` does: --since, ranges, --author, paths.
# Authors listed in ~/.gitignore-users are filteRED out.

# If output is going to a terminal
if [ -t 1 ]; then
  GREEN=$(printf '\033[32m')
  RED=$(printf '\033[31m')
  RESET=$(printf '\033[0m')
fi

git log --format='@%aN <%aE>' --numstat "$@" |
awk -F'\t' -v GREEN="$GREEN" -v RED="$RED" -v RESET="$RESET" '
  /^@/ {
    author = substr($0, 2)
    commits[author]++
    next
  }
  NF == 3 {
    added[author] += $1    # binary files report "-", which counts as 0
    removed[author] += $2
  }
  END {
    # Pad the lines column on its uncoloRED width so the names line up.
    for (author in commits) {
      delta[author] = added[author] - removed[author]
      lines[author] = sprintf("+%d/-%d Δ %+d", added[author], removed[author], delta[author])
      if (length(lines[author]) > width) width = length(lines[author])
    }
    for (author in commits) {
      padding = sprintf("%*s", width - length(lines[author]), "")
      delta_color = delta[author] > 0 ? GREEN : delta[author] < 0 ? RED : ""
      printf "%6d\t%s+%d%s/%s-%d%s Δ %s%+d%s%s\t%s\n",
        commits[author],
        GREEN, added[author], RESET,
        RED, removed[author], RESET,
        delta_color, delta[author], RESET,
        padding, author
    }
  }
' |
grep -vf ~/.gitignore-users |
sort -rn
