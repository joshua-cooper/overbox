{ writeScriptBin, runtimeShell, symlinkJoin, bubblewrap, fd }:

let
  wrapped = [
    (writeScriptBin "fd" ''
      #!${runtimeShell}

      exec ${bubblewrap}/bin/bwrap \
        --ro-bind / / \
        --unshare-all \
        --hostname sandbox \
        --die-with-parent \
        --new-session \
        ${fd}/bin/fd "$@"
    '')
  ];
in symlinkJoin {
  name = "fd";
  paths = wrapped ++ [ fd ];
}
