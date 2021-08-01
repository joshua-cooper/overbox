{ writeScriptBin, runtimeShell, symlinkJoin, bubblewrap, exa }:

let
  wrapped = [
    (writeScriptBin "exa" ''
      #!${runtimeShell}

      exec ${bubblewrap}/bin/bwrap \
        --ro-bind / / \
        --unshare-all \
        --hostname sandbox \
        --die-with-parent \
        --new-session \
        ${exa}/bin/exa "$@"
    '')
  ];
in symlinkJoin {
  name = "exa";
  paths = wrapped ++ [ exa ];
}
