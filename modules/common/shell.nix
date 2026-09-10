{ pkgs, ... }:
let
  toToml = (pkgs.formats.toml { }).generate;

  irisStarshipConfig = toToml "starship-iris.toml" {
    format = ''
      $hostname$username$directory$git_branch$nix_shell
      $character '';

    add_newline = true;

    hostname = {
      ssh_only = true;
      format = "[](fg:248)[󰒍 $hostname](bg:248 fg:239)[](fg:248) ";
      trim_at = ".";
      disabled = false;
    };

    username = {
      format = "[](fg:252)[ $user](bg:252 fg:253)[](fg:252) ";
      show_always = true;
    };

    directory = {
      format = "[](fg:255)[󰉋 $path$read_only](bg:255 fg:232)[](fg:255) ";
      read_only = " ";
      truncation_length = 1;
    };

    git_branch = {
      format = "[](fg:245)[󰊢 $branch](bg:245 fg:244)[](fg:245) ";
      truncation_length = 24;
      truncation_symbol = "…";
    };

    nix_shell = {
      format = "[](fg:245)[ $state(\\($name\\))](bg:245 fg:blue)[](fg:245) ";
    };

    character = {
      format = "$symbol";
      success_symbol = "[](bold fg:255)";
      error_symbol = "[](bold fg:249)";
      vimcmd_symbol = "[](bold fg:245)";
      vimcmd_visual_symbol = "[](bold fg:245)";
      vimcmd_replace_symbol = "[](bold fg:245)";
      vimcmd_replace_one_symbol = "[](bold fg:245)";
    };
  };

  # TODO: tty prompt without icons
  fallbackStarshipPrompt = toToml "starship-fallback.toml" {
    format = ''
      $hostname$username$directory$git_branch$nix_shell
      $character '';

    add_newline = true;

    hostname = {
      ssh_only = true;
      format = "[󰒍 $hostname](fg:bright-red) ";
      trim_at = ".";
      disabled = false;
    };

    username = {
      format = "[@$user](fg:bright-green) ";
      show_always = true;
    };

    directory = {
      format = "in [󰉋 $path$read_only](fg:bright-yellow) ";
      read_only = " (readonly)";
      truncation_length = 1;
    };

    git_branch = {
      format = "[󰊢 $branch](fg:bright-cyan) ";
      truncation_length = 24;
      truncation_symbol = "…";
    };

    nix_shell = {
      format = "[$state(\\($name\\))](fg:bright-magenta) ";
    };

    character = {
      format = "$symbol";
      success_symbol = "[\\$](fg:green)";
      error_symbol = "[\\$](fg:red)";
    };
  };

  ttyStarshipPrompt = toToml "starship-tty.toml" {};
in
{
  programs.zoxide = {
    enable = true;
    flags = [
      "--cmd cd"
    ];
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      if test -n "$SSH_CONNECTION" -o -n "$SSH_TTY"
        function fish_greeting
          set -l uptime_sec 0
          if test -r /proc/uptime
            set uptime_sec (math -s0 (cat /proc/uptime | awk '{print $1}'))
          end

          set -l days (math -s0 "$uptime_sec / 86400")
          set -l hours (math -s0 "($uptime_sec % 86400) / 3600")
          set -l mins (math -s0 "($uptime_sec % 3600) / 60")

          set -l time_str ""
          test $days -gt 0; and set time_str "$time_str"$days"d "
          test $hours -gt 0; and set time_str "$time_str"$hours"h "
          set time_str "$time_str"$mins"m"

          echo (set_color cyan --bold)"Hey!" (set_color normal)(set_color --dim)"(up $time_str)"(set_color normal)
        end
      else
        set -g fish_greeting
      end

      fish_vi_key_bindings
    '';

    shellAbbrs = {
      nsh = "nix shell nixpkgs#";
    };
  };

  programs.starship.enable = true;
  programs.fish.shellInit = ''
    if set -q SUPPORTS_IRIS_PALETTE
      set -gx STARSHIP_CONFIG "${irisStarshipConfig}"
    else
      set -gx STARSHIP_CONFIG "${fallbackStarshipPrompt}"
    end
  '';

  # Superior shell
  environment.shells = [ pkgs.fish ];
  users.defaultUserShell = pkgs.fish;
}
