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
    old=$(git branch)
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
    git checkout $1
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
