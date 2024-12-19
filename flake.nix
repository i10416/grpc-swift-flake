{
  description = "gRPC Swift protoc plugins";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.grpc-swift-src = {
    url = "github:grpc/grpc-swift?ref=refs/tags/1.23.1";
    flake = false;
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, grpc-swift-src }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { pkgs, system, ... }:
        let
          pkgs = import nixpkgs { inherit system; };
          protobuf = pkgs.protobuf;
          version = "1.23.1";
          protoc-gen-swift = import ./protoc-gen-swift/default.nix {
            inherit pkgs system grpc-swift-src version;
          };
          protoc-gen-grpc-swift = import ./protoc-gen-grpc-swift/default.nix {
            inherit pkgs system grpc-swift-src version;
          };
        in rec {
          packages = {
            protoc-gen-swift = protoc-gen-swift;
            protoc-gen-grpc-swift = protoc-gen-grpc-swift;
            default = packages.protoc-gen-swift;
          };
          devShells = {
            default = pkgs.mkShell {
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
          };
        };
    };
}
