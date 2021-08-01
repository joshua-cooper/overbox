{ writeScriptBin, runtimeShell, symlinkJoin, bubblewrap, mako }:

let
  wrapped = [
    (writeScriptBin "mako" ''
      #!${runtimeShell}

      exec ${bubblewrap}/bin/bwrap \
        --dev /dev \
        --ro-bind /nix/store /nix/store \
        --ro-bind /etc/fonts /etc/fonts \
        --ro-bind /run/user/"$(id -u)"/bus /run/user/"$(id -u)"/bus \
        --ro-bind /run/user/"$(id -u)"/wayland-1 /run/user/"$(id -u)"/wayland-1 \
        --ro-bind "$HOME"/.config/mako "$HOME"/.config/mako \
        --unshare-all \
        --hostname sandbox \
        --die-with-parent \
        --new-session \
        ${mako}/bin/mako "$@"
    '')

    (writeScriptBin "makoctl" ''
      #!${runtimeShell}

      exec ${bubblewrap}/bin/bwrap \
        --dev /dev \
        --ro-bind /nix/store /nix/store \
        --ro-bind /run/user/"$(id -u)"/bus /run/user/"$(id -u)"/bus \
        --ro-bind /run/current-system/sw/bin/busctl /run/current-system/sw/bin/busctl \
        --unshare-all \
        --hostname sandbox \
        --die-with-parent \
        --new-session \
        ${mako}/bin/makoctl "$@"
    '')
  ];
in symlinkJoin {
  name = "mako";
  paths = wrapped ++ [ mako ];
}
