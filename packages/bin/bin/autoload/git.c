# vim:syntax=sh
# vim:filetype=sh

git.c () {
    # --------------
    # Validate input
    if [ ! $# -eq 0 ]; then
        # This does not preserve single-quotes
        #COMMIT_MESSAGE="$@"
        # This comes from here: https://unix.stackexchange.com/questions/197792/joining-bash-arguments-into-single-string-with-spaces
        COMMIT_MESSAGE="$*"
    else
        COMMIT_MESSAGE=""
    fi
    if [ -z "$COMMIT_MESSAGE" ]; then
        echo 'Syntax:' $0 'text for commit message'
        return 2
    fi
    
    # Stage (upon validation)
    git status
    gbp_user_validate "Stage changes"
    if [ $? -eq 0 ] ; then
        return 1
    fi
    git add .
    
    # Commit (upon validation)
    git status
    gbp_user_validate "Commit with message {$COMMIT_MESSAGE}"
    if [ $? -eq 0 ] ; then
        return 1
    fi
    git commit -m "$COMMIT_MESSAGE"
    
    # TODO: Merge with remote (upon validation)
    # See this for some tips: https://stackoverflow.com/questions/17719829/check-if-local-git-repo-is-ahead-behind-remote
    #gbp_user_validate "Merge with remote"
}
