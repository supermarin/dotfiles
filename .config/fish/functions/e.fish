function e
  set -l file
  if [ (count $argv) -ne 1 ]
    set file (fzf --preview 'bat --style=numbers --color=always {} | head -500')
    if [ $status -ne 0 ]
      return
    end
  else
    set file $argv[1]
  end
  $EDITOR $file
end
