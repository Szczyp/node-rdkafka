{ pkgs ? import <nixpkgs> {} }:
let
  name = "node-rdkafka";
  version = "2.7.4";

  nodejs = pkgs.nodejs-12_x;

  rdkafka = with pkgs; stdenv.mkDerivation rec {
    pname = "rdkafka";
    version = "1.2.2";

    src = fetchFromGitHub {
      owner = "edenhill";
      repo = "librdkafka";
      rev = "v${version}";
      sha256 = "1daikjr2wcjxcys41hfw3vg2mqk6cy297pfcl05s90wnjvd7fkqk";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ zlib perl python openssl ];

    NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

    postPatch = ''
      patchShebangs .
    '';
  };

  pnpm2nix = import (pkgs.fetchFromGitHub {
    owner = "adisbladis";
    repo = "pnpm2nix";
    rev = "master";
    sha256 = "1ck4k4qlwrdvs22ar2hvcn26lj17i481prwa4a684nd344fi191z";
  }) { inherit pkgs nodejs; inherit (pkgs) nodePackages; };

  drv = pnpm2nix.mkPnpmPackage {
    src = ./.;
    LIBRDKAFKA=rdkafka;
  };

  shell = pkgs.mkShell {
    shellHook = ''
      export LIBRDKAFKA=${rdkafka}
    '';
    buildInputs = [ nodejs ] ++ (with pkgs.nodePackages; [ pnpm typescript typescript-language-server ]);
  };
in
drv // { inherit shell; }
