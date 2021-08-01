{ writeScriptBin, runtimeShell, symlinkJoin, bubblewrap, ripgrep }:

let
  wrapped = [
    (writeScriptBin "rg" ''
      #!${runtimeShell}

      exec ${bubblewrap}/bin/bwrap \
        --ro-bind / / \
        --unshare-all \
        --hostname sandbox \
        --die-with-parent \
        --new-session \
        ${ripgrep}/bin/rg "$@"
    '')
  ];
in symlinkJoin {
  name = "ripgrep";
  paths = wrapped ++ [ ripgrep ];
}
