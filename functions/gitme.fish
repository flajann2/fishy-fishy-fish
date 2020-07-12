function gitme -d "will add and commit your changes to git, and push them remotely"
    if  test -f 'Gemfile'
        bundle exec rake gemspec
    end
    git add .
    git commit
    git push -u
end
