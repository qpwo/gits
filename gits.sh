#!/usr/bin/env bash

set -euo pipefail

function undo-commit() {
    git reset --soft HEAD~1
    git push -f
}

function delete-branch() {
    git push -d origin $1
    git branch -d $1
}

function ammend-message() {
    git commit --ammend -m "$1"
}

function rename-branch() {
    old=$(git branch --show-current)
    git branch -M $1
    git push origin -u $1
    git push origin --delete $old
}

function unadd() {
    git reset $1
}

function pull-overwrite() {
    git reset --hard HEAD
    git pull
}

function discard() {
    git restore $1
}

function discard-everything() {
    git clean -f
}

function checkout() {
    git fetch origin
    git switch $1
}

function untrack() {
    echo $1 >>.gitignore
    git rm -r --cached $1
    git add $1
}

function merge-in-main() {
    git fetch
    git merge origin/main
}

function new-branch() {
    git checkout -b $1
    git push -u origin $1
}

function push-all-branches() {
    git push --all -u
}

function add-empty-dir() {
    echo '*' >>$1/.gitignore
    echo '!.gitignore' >>$1/.gitignore
    git add $1
}

function combine-last-n-commits() {
    git stash
    git reset --hard HEAD~$1
    git merge --squash HEAD@{1}
    git commit
    git push -f
}

function back-to-last-pushed() {
    git reset --hard origin/$(git branch --show-current)
}

function delete-remote-tag() {
    git push --delete origin $1
}

function change-url() {
    git remote set-url origin $1
}

function undo-rebase() {
    git reset --hard ORIG_HEAD
}

function move-working-tree-to-branch() {
    git switch -c $1
}

function file-history() {
    git log -p -- $1
}

function current-branch() {
    git branch --show-current
}

function files-in-commit() {
    git diff-tree --no-commit-id --name-only -r $1
}

function undo-hard-reset() {
    git reset 'HEAD@{1}'
}

function set-commit-editor() {
    git config --global core.editor
}

function push-tag() {
    git push origin $1
}

function push-all-tags() {
    git push --follow-tags
}

function stash-interactive() {
    git stash push -p -m $1
}

function apply-commit() {
    git cherry-pick -x $1
}

function export() {
    git archive --format zip --output export.zip main
    echo export.zip
}

function show-staged() {
    git diff --staged
}

function last-commit-hash() {
    git rev-parse --short HEAD
}

function delete-all-merged-branches() {
    git branch --merged | egrep -v "(^\*|master|main)" | xargs git branch -d
    git remote prune origin
    git push
}

function branch-from-n-before() {
    git checkout -b $1 HEAD~$2
}

function ignore-except() {
    echo '*' >>.gitignore
    for var in "$@"; do
        echo "!$var" >>.gitignore
    done
}

function update-all-submodules() {
    git submodule update --recursive --remote
}

function unpushed-commits() {
    git log origin/$(git branch --show-current)..HEAD
}

function unpushed-commits-diff() {
    git diff origin/$(git branch --show-current)..HEAD
}

function clone-at-tag() {
    git clone -b $2 --single-branch --depth 1 $1
}

function clone-shallow() {
    git clone $1 --depth 1
}

function pull-all-branches() {
    git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all
}
