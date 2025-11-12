{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.neofetch;

  # Helper function to convert a single hex character to decimal
  hexCharToInt = c:
    if c == "0"
    then 0
    else if c == "1"
    then 1
    else if c == "2"
    then 2
    else if c == "3"
    then 3
    else if c == "4"
    then 4
    else if c == "5"
    then 5
    else if c == "6"
    then 6
    else if c == "7"
    then 7
    else if c == "8"
    then 8
    else if c == "9"
    then 9
    else if c == "a" || c == "A"
    then 10
    else if c == "b" || c == "B"
    then 11
    else if c == "c" || c == "C"
    then 12
    else if c == "d" || c == "D"
    then 13
    else if c == "e" || c == "E"
    then 14
    else if c == "f" || c == "F"
    then 15
    else 0;

  # Helper function to convert two hex characters to decimal (0-255)
  hexPairToInt = hex: let
    high = builtins.substring 0 1 hex;
    low = builtins.substring 1 1 hex;
  in
    (hexCharToInt high) * 16 + (hexCharToInt low);

  # Helper function to convert hex color to ANSI escape code
  hexToAnsi = hex: let
    # Remove # if present
    cleanHex = lib.removePrefix "#" hex;
    # Extract RGB values
    r = hexPairToInt (builtins.substring 0 2 cleanHex);
    g = hexPairToInt (builtins.substring 2 2 cleanHex);
    b = hexPairToInt (builtins.substring 4 2 cleanHex);
  in "\\033[38;2;${toString r};${toString g};${toString b}m";

  # Map base16 colors to ANSI escape codes
  colors = {
    base00 = hexToAnsi config.colorScheme.palette.base00;
    base01 = hexToAnsi config.colorScheme.palette.base01;
    base02 = hexToAnsi config.colorScheme.palette.base02;
    base03 = hexToAnsi config.colorScheme.palette.base03;
    base04 = hexToAnsi config.colorScheme.palette.base04;
    base05 = hexToAnsi config.colorScheme.palette.base05;
    base06 = hexToAnsi config.colorScheme.palette.base06;
    base07 = hexToAnsi config.colorScheme.palette.base07;
    base08 = hexToAnsi config.colorScheme.palette.base08; # Red
    base09 = hexToAnsi config.colorScheme.palette.base09; # Orange
    base0A = hexToAnsi config.colorScheme.palette.base0A; # Yellow
    base0B = hexToAnsi config.colorScheme.palette.base0B; # Green
    base0C = hexToAnsi config.colorScheme.palette.base0C; # Cyan
    base0D = hexToAnsi config.colorScheme.palette.base0D; # Blue
    base0E = hexToAnsi config.colorScheme.palette.base0E; # Magenta
    base0F = hexToAnsi config.colorScheme.palette.base0F; # Brown
    reset = "\\033[0m";
  };

  neofetchConfig =
    /*
    bash
    */
    ''
      print_info() {
          info "${colors.base0B} ╭─󱄅" distro   # Green
          info "${colors.base0B} ├─" kernel     # Green
          info "${colors.base0B} ├─" users      # Green
          info "${colors.base0B} ├─󰏗" packages   # Green
          info "${colors.base0B} ╰─" shell      # Green
          echo
          info "${colors.base0A} ╭─" de         # Yellow
          info "${colors.base0A} ├─" term       # Yellow
          info "${colors.base0A} ╰─" term_font  # Yellow
          info "${colors.base0A} ├─󰂫" theme      # Yellow
          info "${colors.base0A} ├─󰂫" icons      # Yellow
          info "${colors.base0A} ╰─" font       # Yellow
          echo
          info "${colors.base0D} ╭─" model      # Blue
          info "${colors.base0D} ├─󰍛" cpu        # Blue
          info "${colors.base0D} ├─󰍹" gpu        # Blue
          info "${colors.base0D} ├─" resolution # Blue
          info "${colors.base0D} ├─" memory     # Blue
          info "${colors.base0D} ├─ ${colors.reset}" disk  # Blue, then reset
          info "${colors.base0D} ╰─󰄉" uptime     # Blue
      }

      title_fqdn="on"
      kernel_shorthand="on"
      distro_shorthand="on"
      os_arch="off"
      uptime_shorthand="tiny"
      memory_percent="on"
      memory_unit="Gib"
      package_managers="on"
      shell_path="off"
      shell_version="on"
      speed_type="scaling_max_freq"
      speed_shorthand="on"
      cpu_brand="off"
      cpu_speed="on"
      cpu_cores="logical"
      cpu_temp="on"
      gpu_brand="off"
      gpu_type="all"
      refresh_rate="on"
      gtk_shorthand="off"
      gtk2="off"
      gtk3="off"
      public_ip_host="http://ident.me"
      public_ip_timeout=2
      de_version="on"
      disk_show=('/home')
      disk_subtitle="mount"
      disk_percent="on"
      music_player="auto, amberol"
      song_format="%artist% - %album% - %title%"
      song_shorthand="off"
      mpc_args=()
      colors=(distro)
      bold="on"
      underline_enabled="on"
      underline_char="󰍴"
      separator=" "
      block_range=(1 8)

      # Color definitions using nix-colors
      magenta="${colors.base0E}"
      green="${colors.base0B}"
      white="${colors.base05}"
      blue="${colors.base0D}"
      red="${colors.base08}"
      black="${colors.base00}"
      yellow="${colors.base0A}"
      cyan="${colors.base0C}"
      reset="${colors.reset}"

      color_blocks="on"
      block_width=4
      block_height=1
      col_offset="auto"
      bar_char_elapsed="-"
      bar_char_total="="
      bar_border="on"
      bar_length=15
      bar_color_elapsed="distro"
      bar_color_total="distro"
      cpu_display="on"
      memory_display="on"
      battery_display="on"
      disk_display="on"
      image_backend="chafa"
      image_source="${config.home.homeDirectory}/.config/nix-config/home/assets/logo.png"
      ascii_distro="off"
      ascii="off"
      ascii_colors=(distro)
      ascii_bold="on"
      image_loop="on"
      thumbnail_dir="${config.xdg.cacheHome}/thumbnails/neofetch"
      crop_mode="normal"
      crop_offset="center"
      image_size="300px"
      gap=2
      yoffset=1
      xoffset=0
      background_color=
      stdout="off"
    '';
in {
  options.features.cli.neofetch.enable = mkEnableOption "enable neofetch";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [neofetch imagemagick];
    home.file.".config/neofetch/config.conf".text = lib.mkForce neofetchConfig;
  };
}
