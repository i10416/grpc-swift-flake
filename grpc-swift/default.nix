{ pkgs ? import <nixpkgs> { inherit system; }, system ? builtins.currentSystem
, grpc-swift-src, product }:
let
  pname = "grpc-swift";
  generated = pkgs.swiftpm2nix.helpers ./swiftpm2nix;
in pkgs.swift.stdenv.mkDerivation rec {
  src = grpc-swift-src;
  configurePhase = generated.configure;
  nativeBuildInputs =
    (with pkgs; [ swift swiftPackages.swiftpm swift-corelibs-libdispatch ]);
  name = "grpc-swift";
  buildPhase = ''
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:${pkgs.swift}/lib/swift/clang/include/
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath nativeBuildInputs}
    swift build -c release --product ${product}
  '';
  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    install -Dm555 $binPath/${product} $out/bin/${product}
  '';
  meta = {
    description = "The Swift language implementation of gRPC.";
    longDescription = ''
      Nix derivation for Swift protoc plugins for protobuf and gRPC.
    '';
    homepage = "https://github.com/grpc/grpc-swift";
  };
}
