# will recurse. use with care.
function nospaces
    # set -x PATH=(echo $PATH | perl -pe "s/:~\/\.local\/bin//g")
    find ./ -depth -name "* *" -execdir rename 's/ /_/g' "{}" \;
end
