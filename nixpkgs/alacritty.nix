{
  enable = true;
  settings = {
    env = {
      TERM = "xterm-256color";
    };
    font = {
      size = 11;
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
    extraConfig = ''
      colors:
        # Default colors
        primary:
          background: '0x282828'
          foreground: '0xeeeeee'

        # Normal colors
        normal:
          black:   '0x282828'
          red:     '0xf43753'
          green:   '0xc9d05c'
          yellow:  '0xffc24b'
          blue:    '0xb3deef'
          magenta: '0xd3b987'
          cyan:    '0x73cef4'
          white:   '0xeeeeee'

        # Bright colors
        bright:
          black:   '0x4c4c4c'
          red:     '0xf43753'
          green:   '0xc9d05c'
          yellow:  '0xffc24b'
          blue:    '0xb3deef'
          magenta: '0xd3b987'
          cyan:    '0x73cef4'
          white:   '0xfeffff'
    '';
  };
}
