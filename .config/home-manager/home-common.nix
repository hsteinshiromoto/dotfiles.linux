{ config, pkgs, homeDirectory, username, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
		# pkgs.awscli
		# pkgs.bat
		# pkgs.btop
		# pkgs.cargo
		# pkgs.eza
		# pkgs.fd
		#   pkgs.fzf
		# pkgs.git
		# pkgs.gitflow
		# pkgs.gnupg
		#   pkgs.hello
		# pkgs.lazygit
		# pkgs.nerd-fonts.jetbrains-mono
		# pkgs.ripgrep
		# pkgs.starship
		# pkgs.tmux
		# pkgs.tmuxinator
		# pkgs.uv
		# pkgs.yazi
		#   pkgs.zoxide
		# pkgs.zsh
		# pkgs.zsh-autosuggestions
		# pkgs.zsh-syntax-highlighting
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
		# ---
		# References:
		#   [1] https://github.com/omerxx/dotfiles/blob/master/nix-darwin/home.nix
		# ---
		".zshrc".source = "${config.home.homeDirectory}/dotfiles/.zshrc";
		".config/starship.toml".source = "${config.home.homeDirectory}/dotfiles/.config/starship.toml";
		".tmux.conf".source = "${config.home.homeDirectory}/dotfiles/.tmux.conf";
		".config/nvim" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";
  };

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/hsteinshiromoto/etc/profile.d/hm-session-vars.sh
  #
	home.sessionPath = [
		"$HOME/.nix-profile/bin"
		"/opt/nvim-linux-x86_64/bin"
	];
  home.sessionVariables = {
    EDITOR = "nvim";
  };

   # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.zsh ={
			enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
			builtins.readFile ./zshrc;
    '';
	};
	programs.git = {
		enable = true;
		userName = "Humberto STEIN SHIROMOTO";
		userEmail = "hsteinshiromoto@gmail.com";
	};
}
