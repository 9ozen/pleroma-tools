{ lib, stdenv, writeShellApplication, symlinkJoin, curl, jq }:
let
  name    = "pleroma-tools";
  scripts = lib.mapAttrsToList (n: v: ./src + ("/" + n))
              (lib.filterAttrs (n: v: v == "regular") (builtins.readDir ./src));
  wrapScript = script: writeShellApplication {
    name = lib.last (builtins.split "/" (toString script));
    runtimeInputs = [ curl jq ];
    text = builtins.readFile script;
  };
in
  symlinkJoin { name = name; paths = map wrapScript scripts; }
