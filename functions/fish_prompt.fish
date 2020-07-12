function fish_prompt
    # This prompt shows:
    # - green lines if the last return command is OK, red otherwise
    # - your user name, in red if root or yellow otherwise
    # - your hostname, in cyan if ssh or blue otherwise
    # - the current path (with prompt_pwd)
    # - date +%X
    # - the current virtual environment, if any
    # - the current git status, if any, with fish_git_prompt
    # - the current battery state, if any, and if your power cable is unplugged, and if you have "acpi"
    # - current background jobs, if any

    # It goes from:
    # ┬─[nim@Hattori:~]─[11:39:00]
    # ╰─>$ echo here

    # To:
    # ┬─[nim@Hattori:~/w/dashboard]─[11:37:14]─[V:django20]─[G:master↑1|●1✚1…1]─[B:85%, 05:41:42 remaining]
    # │ 2	15054	0%	arrêtée	sleep 100000
    # │ 1	15048	0%	arrêtée	sleep 100000
    # ╰─>$ echo there

    set -l retc red
    test $status = 0; and set retc green

    set -q __fish_git_prompt_showupstream
    or set -g __fish_git_prompt_showupstream auto

    set -q __fish_git_prompt_showdirtystate
    or set -g __fish_git_prompt_showdirtystate auto

    set -g __fish_git_prompt_showstashstate auto
    set -g __fish_git_prompt_showuntrackedfiles auto
    #set -g __fish_git_prompt_showupstream verbose git name
    set -g __fish_git_prompt_describe_style branch
    set -g __fish_git_prompt_showcolorhints auto
    set -g fish_term24bit 1
    set -g _gitroot (git rev-parse --show-toplevel 2>/dev/null)
    
    function _nim_prompt_wrapper
        set retc $argv[1]
        set field_name $argv[2]
        set field_value $argv[3]

        set_color normal
        set_color $retc
        echo -n '─'
        set_color -o green
        echo -n '['
        set_color normal
        test -n $field_name
        and echo -n $field_name:
        set_color $retc
        echo -n $field_value
        set_color -o green
        echo -n ']'
    end

    function _git_root
        git rev-parse --show-toplevel 2>/dev/null
    end

    function _ruby_live_version 
        set retc $argv[1]
        set rver (ruby -v | cut -d ' ' -f 2)
        set rbfile "$_gitroot/Gemfile"
        if test -f $rbfile
            and test -n "$rver" 
            set_color $retc
            echo -n '─'
            set_color -o green
            echo -n '['
            set_color 702
            echo -n 'rb '
            set_color F04
            echo -n $rver
            set_color -o green
            echo -n ']'
            set_color normal
        end
    end

    function _rust_live_version 
        set retc $argv[1]
        set rsfile "$_gitroot/Cargo.toml"
        set rustver (rustc --version | cut -d ' ' -f 2)
        if test -f $rsfile
            and test -n $rustver
            set_color $retc
            echo -n '─'
            set_color -o green
            echo -n '['
            set_color -o 852
            echo -n 'rs '
            set_color -o FA4
            echo -n $rustver
            set_color -o green
            echo -n ']'
            set_color normal
        end
    end

    function _elixir_live_version 
        set retc $argv[1]
        set exfile "$_gitroot/mix.exs"
        set xver (elixirc --version | tail -n 1 | cut -d ' ' -f 2)
        if test -f $exfile
            and test -n $xver
            set_color $retc
            echo -n '─'
            set_color -o green
            echo -n '['
            set_color -o 808
            echo -n 'ex '
            set_color -o F0F
            echo -n $xver
            set_color -o green
            echo -n ']'
            set_color normal
        end
    end

    function _cpp_live_versions 
        set retc $argv[1]
        set clangver (clang++ --version | head -n1 | cut -d ' ' -f 3 | cut -d '-' -f 1 )
        set gccver (g++ --version | head -n1 | cut -d ' ' -f 3 | cut -d '-' -f 1 )
        set cfile "$_gitroot/CMakeLists.txt"
        if begin test -n $clangver; or test -n $gccver; end; and test -f $cfile
            set_color $retc
            echo -n '─'
            set_color -o green
            echo -n '['

            # clang
            set_color -o 007777
            echo -n 'c++ '
            set_color -o 00BBBB
            echo -n $clangver

            # gcc
            set_color -o 764466
            echo -n ' g++ '
            set_color -o BC66BC
            echo -n $gccver
            
            set_color -o green
            echo -n ']'
            set_color normal
        end
    end
    
    set_color $retc
    echo
    echo -n '┬─'
    set_color -o green
    echo -n [
    if test "$USER" = root -o "$USER" = toor
        set_color -o red
    else
        set_color -o yellow
    end
    echo -n $USER
    set_color -o white
    echo -n @
    if [ -z "$SSH_CLIENT" ]
        set_color -o blue
    else
        set_color -o cyan
    end
    echo -n (prompt_hostname)
    set_color -o white
    echo -n :(prompt_pwd)
    set_color -o green
    echo -n ']'

    # Virtual Environment
    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and _nim_prompt_wrapper $retc V (basename "$VIRTUAL_ENV")

    # git
    set prompt_git (fish_git_prompt | string trim -c ' ()')
    test -n "$prompt_git"
    and _nim_prompt_wrapper $retc G $prompt_git

    # languages
    _ruby_live_version
    _rust_live_version
    _elixir_live_version
    _cpp_live_versions
    
    # Battery status
    type -q acpi
    and test (acpi -a 2> /dev/null | string match -r off)
    and _nim_prompt_wrapper $retc B (acpi -b | cut -d' ' -f 4-)

    # New line
    echo

    # Background jobs
    set_color normal
    for job in (jobs)
        set_color $retc
        echo -n '│ '
        set_color brown
        echo $job
    end
    set_color normal
    set_color $retc
    echo -n '╰─>'
    set_color -o red
    echo -n 'λ '
    set_color normal
end
