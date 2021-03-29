{
  enable = true;
  settings = {
    env = {
      TERM = "xterm-256color";
    };
    font = {
      size = 10;
    };
    window = {
      padding = {
        x = 10;
        y = 5;
      };
    };
    keybindings = [
      { key = "Equals";     mods = "Control";     action = "IncreaseFontSize"; }
      { key = "Add";        mods = "Control";     action = "IncreaseFontSize"; }
      { key = "Subtract";   mods = "Control";     action = "DecreaseFontSize"; }
      { key = "Minus";      mods = "Control";     action = "DecreaseFontSize"; }
    ];
    draw_bold_text_with_bright_colors = true;
  };
}
