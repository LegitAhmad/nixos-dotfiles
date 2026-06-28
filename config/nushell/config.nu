# Custom command 'mc' (mkdir and cd) ported from Fish
def --env mc [path: string] {
  mkdir $path
  cd $path
}

# 1. Define Carapace completer (generic static implementation)
let carapace_completer = {|spans|
  load-env {
    CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq  | str join "\n")
    CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq  | str join "\n")
  }
  let expanded_alias = (scope aliases | where name == ($spans | first) | get -o 0 | get -o expansion)
  let spans = (if $expanded_alias != null  {
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans | skip 1 | prepend ($spans | first)
  })
  carapace ($spans | first) nushell ...$spans | from json
}

# 2. Save it to CARAPACE_COMPLETER so fzf.nu can load it safely
$env.CARAPACE_COMPLETER = $carapace_completer

# Custom command 'y' to run yazi and cd into the last directory on exit
def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  ^yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != $env.PWD and ($cwd | path exists) {
    cd $cwd
  }
  ^rm -f $tmp
}

# 3. Source Fzf integration (which wraps $env.CARAPACE_COMPLETER and registers itself)
source ~/.config/nushell/fzf.nu

# NixOS & Home Manager helper (nh) shortcuts
alias nrs = nh os switch
alias nrb = nh os boot
alias nru = nh os switch --update
alias ncg = nix-collect-garbage -d

# Git shortcuts
alias g = git
alias ga = git add
alias gc = git commit
alias gp = git push
alias gs = git status
alias gd = git diff
alias gl = git log --oneline -n 10

# Safety alias
alias rm = trash-put

# Eza shortcuts (since eza and ls are kept separate)
alias e = eza
alias ea = eza -a
alias el = eza -l
alias ela = eza -la
