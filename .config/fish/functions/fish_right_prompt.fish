function fish_right_prompt
  set -l right_color (set_color brown)
  echo $right_color $PWD | awk -F/ '{print $1 $(NF-1) "/" $(NF)}'
  set_color normal
end

