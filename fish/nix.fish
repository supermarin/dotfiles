if [ -n "$HOME" ] && [ -n "$USER" ]
    # This part should be kept in sync with nixpkgs:nixos/modules/programs/shell.nix
    set NIX_LINK $HOME/.nix-profile

    set NIX_USER_PROFILE_DIR /nix/var/nix/profiles/per-user/$USER

    # Append ~/.nix-defexpr/channels to $NIX_PATH so that <nixpkgs>
    # paths work when the user has fetched the Nixpkgs channel.
    set -gx NIX_PATH $HOME/.nix-defexpr/channels

    # Set up environment.
    # This part should be kept in sync with nixpkgs:nixos/modules/programs/environment.nix
    set -gx NIX_PROFILES "/nix/var/nix/profiles/default $HOME/.nix-profile"

    # Set $NIX_SSL_CERT_FILE so that Nixpkgs applications like curl work.
    if [ -e /etc/ssl/certs/ca-certificates.crt ] # NixOS, Ubuntu, Debian, Gentoo, Arch
        set -gx NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
    else if [ -e /etc/ssl/ca-bundle.pem ] # openSUSE Tumbleweed
        set -gx NIX_SSL_CERT_FILE /etc/ssl/ca-bundle.pem
    else if [ -e /etc/ssl/certs/ca-bundle.crt ] # Old NixOS
        set -gx NIX_SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
    else if [ -e /etc/pki/tls/certs/ca-bundle.crt ] # Fedora, CentOS
        set -gx NIX_SSL_CERT_FILE /etc/pki/tls/certs/ca-bundle.crt
    else if [ -e "$NIX_LINK/etc/ssl/certs/ca-bundle.crt" ] # fall back to cacert in Nix profile
        set -gx NIX_SSL_CERT_FILE "$NIX_LINK/etc/ssl/certs/ca-bundle.crt"
    else if [ -e "$NIX_LINK/etc/ca-bundle.crt" ] # old cacert in Nix profile
        set -gx NIX_SSL_CERT_FILE "$NIX_LINK/etc/ca-bundle.crt"
    end

    if [ -n "$MANPATH-" ]
        set -gx MANPATH "$NIX_LINK/share/man" "$MANPATH"
    end

    set -gx PATH "$NIX_LINK/bin" "$PATH"
    # HACK until nix compiles arm64 binaries
    set -gx PATH "$HOME/.local/bin" "$PATH"
    set -e NIX_LINK
    set -e NIX_USER_PROFILE_DIR
end
