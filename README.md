## grpc-swift flake

## About

This is a repository for grpc-swift wrapped by Nix flake.

This flake provides `protoc-gen-swift` and `protoc-gen-grpc-swift` packages for each system.

```nix
{
  # ...
  inputs.grpc-swift.url = "github:i10416/grpc-swift-flake";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  # ...
  outputs = {self,flake-utils, grpc-swift, ...}:
    flake-utils.lib.eachDefaultSystem (system:
      {
         devShell = pkgs.mkShell {
          name = "...";
          buildInputs = [
            grpc-swift.packages.${system}.protoc-gen-swift
            grpc-swift.packages.${system}.protoc-gen-grpc-swift
          ]
         }
      }
    )
}
```

## Develop

`nix build .` builds `protoc-gen-swift` by default. Run `nix build .#protoc-gen-swift` and `nix build .#protoc-gen-grpc-swift` to build each package.

Derivations under `protoc-gen-swift/` and `protoc-gen-grpc-swift/` can be built by `nix-build` command. They have default grpc-swift source, but they are supposed to be used for debug purpose.

```sh
cd protoc-gen-swift
nix-build .
```

