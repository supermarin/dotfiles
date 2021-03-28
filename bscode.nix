pkgs:

with pkgs; {
  enable = true;
  package = vscodium;
  extensions = [
    vscode-extensions.brettm12345.nixfmt-vscode
    vscode-extensions.jnoortheen.nix-ide
    vscode-extensions.golang.Go
    vscode-extensions.vscodevim.vim
  ];
  userSettings = {
    "editor.fontFamily" = "'SF Mono', 'monospace', monospace";
    "editor.minimap.enabled" = false;
    "go.useLanguageServer" = true;
    "nix.enableLanguageServer" = true;
    "update.mode" = "none";
    "vim.useSystemClipboard" = true;
    "window.autoDetectColorScheme" = true;
    "window.menuBarVisibility" = "toggle";
    "workbench.activityBar.visible" = false;
    "workbench.colorTheme" = "Gruvbox Light Hard";
    "workbench.preferredDarkColorTheme" = "Gruvbox Dark Hard";
    "workbench.preferredLightColorTheme" = "Gruvbox Light Hard";
    "[go]" = {
      "editor.fontFamily" = "'Go Mono', monospace";
    };
  };
}
