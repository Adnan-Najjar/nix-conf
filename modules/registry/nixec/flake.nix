{
  description = "Security tools development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
    }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      packages =
        with pkgs;
        [
          # Web
          burpsuite

          # Networking
          nmap
          wireshark
          tshark
          netcat
          socat
          dnsenum

          # Password cracking
          hashcat
          john

          # Exploitation
          pkgs-unstable.metasploit
          postgresql

          # Reverse Engineering
          detect-it-easy
          radare2
          binaryninja-free
          ghidra-bin

          # Forensics
          binwalk
          volatility3

          # Utility
          python3
          curl
          wget
        ]
        ++ (with pkgs.python3Packages; [
          requests
          beautifulsoup4
          pwntools
        ]);

      mkShellWithProxy =
        name: proxy:
        pkgs.mkShell {
          inherit name;
          inherit packages;
          shellHook = ''
            export PS1="\[\e]0;\u@\h: \w\a\]\[\033[;32m\]┌──''${debian_chroot:+($debian_chroot)──}''${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)\[\033[;32m\])}(\[\033[1;34m\]\u㉿kali\[\033[;32m\])-[\[\033[0;1m\]\w\[\033[;32m\]]\n\[\033[;32m\]└─\[\033[1;34m\]\$\[\033[0m\] "
            export http_proxy="${proxy}"
            export https_proxy="${proxy}"
            export HTTP_PROXY="${proxy}"
            export HTTPS_PROXY="${proxy}"
            export all_proxy="${proxy}"
            msfdb init # run postgresql server for metasploit

            alias chrome="chromium --proxy-server=\"${proxy}\""

            OVPN_FILE=$(ls *.ovpn 2>/dev/null | head -n 1)
            if [ -n "$OVPN_FILE" ]; then
              ${lib.getExe pkgs.openvpn} --config "$OVPN_FILE" --daemon
              echo -e "\033[32mConnected to OpenVPN using $OVPN_FILE\033[0m"
            fi
          '';
        };
    in
    {
      devShells.${system} = {
        default = mkShellWithProxy "nixec" "";

        # Provide any proxy
        proxy = mkShellWithProxy "nixec#proxy" "http://182.253.166.249:5678";

        offline = mkShellWithProxy "nixec#offline" "http://127.0.0.1:1";
      };
    };
}
