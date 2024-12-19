{ pkgs ? import <nixpkgs> { inherit system; }, system ? builtins.currentSystem
, grpc-swift-src, version }:
let
  product = "protoc-gen-grpc-swift";
  grpc-swift =
    import ../grpc-swift { inherit pkgs system grpc-swift-src product; };
in pkgs.stdenv.mkDerivation {
  pname = product;
  version = version;
  src = ./.;
  installPhase = ''
    mkdir -p $out/bin
    install -Dm555 ${grpc-swift}/bin/${product} $out/bin/${product}
  '';
  meta = with pkgs.lib; {
    description =
      "Nix derivation of protoc plugin that generates swift gRPC code from protobuf definitions";
    homepage = "https://github.com/grpc/grpc-swift.git";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
