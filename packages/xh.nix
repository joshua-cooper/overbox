{ writeScriptBin, runtimeShell, symlinkJoin, bubblewrap, xh }:

let
  wrapped = [
    (writeScriptBin "xh" ''
      #!${runtimeShell}

      exec ${bubblewrap}/bin/bwrap \
        --ro-bind /nix/store /nix/store \
        --ro-bind /etc/resolv.conf /etc/resolv.conf \
        --unshare-all \
        --share-net \
        --hostname sandbox \
        --die-with-parent \
        --new-session \
        ${xh}/bin/xh "$@"
    '')
  ];
in symlinkJoin {
  name = "xh";
  paths = wrapped ++ [ xh ];
}
