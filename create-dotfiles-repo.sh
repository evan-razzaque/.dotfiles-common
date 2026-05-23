#!/usr/bin/env bash

DOTFILES_PATH="$1"
if [[ -z "$DOTFILES_PATH" ]]; then
	echo "Missing argument" >&2
	exit 1
fi

DOTFILES_PATH=$(readlink -f "$DOTFILES_PATH")
cd "$(dirname "$(realpath "$0")")" || exit $?

if [[ "$DOTFILES_PATH" == $(readlink -f "$PWD") ]]; then
	echo "Cannot use existing dotfiles directory" >&2
	exit 1
fi

mkdir "$DOTFILES_PATH" || exit $?

# TODO: Rework dependencies

cd "$DOTFILES_PATH" || exit
echo "/.ignore" > ".gitignore"

git init
git submodule add https://github.com/evan-razzaque/.dotfiles-common.git

echo .dotfiles-common/{.stowrc,*} | xargs ln -s -t .
mkdir .ignore
echo .dotfiles-common/.ignore/{*,.*} | xargs ln -sr -t .ignore

rm README.md
cp .dotfiles-common/README.md.template README.md
rm README.md.template

git add .
git add -f .ignore/.stow-local-ignore .ignore/README.txt
git commit -m "Initial commit"
