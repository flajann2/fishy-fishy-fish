function tolower -d "will recurse. use with care."
    # export PATH=$(echo $PATH | perl -pe "s/:~\/\.local\/bin//g")
    find ./ -depth -execdir rename 'y/A-Z/a-z/' "{}" \;
end
