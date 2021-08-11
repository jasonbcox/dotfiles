#!/bin/bash
set -euo pipefail

# Work on PWD rather than top-level
cd -- "${GIT_PREFIX:-.}"

# Full color range: 016 - 231
COLOR_MODE="$1"
shift

TODAY=$(date +%Y-%m-%d)
THIS_YEAR=$(date +%Y)
THIS_MONTH=$(date +%m)
THIS_MONTH=${THIS_MONTH#0}  # Strip leading zeroes, if any
NOW=$(date +%s)

color_age() {
  DATE=$(echo "$1" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
  YEAR=$(echo $DATE | cut -d'-' -f 1)
  SEC=$(date -d "${DATE}" +%s)
  DAYS=$(((NOW - SEC) / 86400))
  MONTHS=$(((NOW - SEC) / 2592000))

  YEAR_DIFF=$((THIS_YEAR - YEAR))
  case ${YEAR_DIFF} in
    [01])
      case ${MONTHS} in
        0)
          case ${DAYS} in
            # Reference: https://unix.stackexchange.com/a/285956
            [0-2]) echo $((196 - DAYS * 36));;
            [3-5]) echo $((197 - (DAYS - 3) * 36));;
            [6-8]) echo $((163 - (DAYS - 6) * 36));;
            9|10|11) echo $((128 - (DAYS - 9) * 36));;
            12|13|14) echo $((93 - (DAYS - 12) * 36));;
            15|16|17|18) echo $((46 - (DAYS - 15) * 6));;
            19|20|21|22) echo $((47 - (DAYS - 19) * 6));;
            23|24|25|26) echo $((49 - (DAYS - 23) * 6));;
            27|28|29|30) echo $((51 - (DAYS - 27) * 6));;
            31|*) echo 23;;
          esac
          ;;
        1)
          echo $((231 - DAYS))
          ;;
        2)
          echo $((87 - DAYS))
          ;;
        3)
          echo $((195 - DAYS))
          ;;
        *)
          # Pale colors
          echo $((123 - MONTHS))
          ;;
      esac
      ;;
    [2-5])
      echo $((253 - (MONTHS - 12 - THIS_MONTH) / 3))
      ;;
    *)
      echo 236
      ;;
  esac
}

color_commit() {
  GIT_HASH=$(echo "$1" | cut -d' ' -f 1)
  echo $((0x${GIT_HASH} % 204 + 28))
}

# COLOR_FUNC must return the 256 GUI terminal color code
case ${COLOR_MODE} in
  age)
    COLOR_FUNC=color_age
    ;;
  *|commit)
    COLOR_FUNC=color_commit
    ;;
esac

while read -r LINE; do
  DIGIT=$(${COLOR_FUNC} "$LINE")
  COLOR="\033[0;38;5;${DIGIT}m"
  echo -e "${COLOR}${LINE}"
done < <(git blame $@)
