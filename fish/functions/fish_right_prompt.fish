function fish_right_prompt
    if test $CMD_DURATION
      # Show notification if dration is more than 30 seconds
      if test $CMD_DURATION -gt 30000
        # Only notify if terminal is not active
        set -l active (swaymsg -t get_tree | jq -r '..|try select(.focused == true)' | jq '.app_id')
        if test $active != '"foot"'
          # Show duration of the last command in seconds
          set -l duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
          set -l title (history | head -1)
          notify-send $title (echo $title returned $status after $duration)
        end
      end
    end

    set -l right_color (set_color brown)
    echo $right_color $PWD | awk -F/ '{print $1 $(NF-1) "/" $(NF)}'
    set_color normal
end
