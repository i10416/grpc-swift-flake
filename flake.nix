{
  description = "gRPC Swift protoc plugins";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.grpc-swift-src = {
    url = "github:grpc/grpc-swift?ref=refs/tags/1.23.0";
    flake = false;
  };
  outputs = { self, nixpkgs, flake-utils, grpc-swift-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        protobuf = pkgs.protobuf;
        protoc-gen-swift = import ./protoc-gen-swift/default.nix {
          inherit pkgs system grpc-swift-src;
        };
        protoc-gen-grpc-swift = import ./protoc-gen-grpc-swift/default.nix {
          inherit pkgs system grpc-swift-src;
        };
      in rec {
        packages = {
          protoc-gen-swift = protoc-gen-swift;
          protoc-gen-grpc-swift = protoc-gen-grpc-swift;
          default = packages.protoc-gen-swift;
        };
        devShell = pkgs.mkShell {
          name = "grpc-swift-shell";
          buildInputs = with pkgs; [
            buf
            git
            curl
            unzip
            iconv
            protobuf
            protoc-gen-swift
            protoc-gen-grpc-swift
          ];
        };
      });
}
