{
  description = "Package the hello repeater.";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.oxygen-xml_22_1.developer =
      let pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      in
      pkgs.stdenv.mkDerivation rec {
        pname = "oxygen-xml-developer";
        version = "22.1";

        src = pkgs.fetchurl {
          url = "https://archives.oxygenxml.com/Oxygen/Developer/InstData${version}/All/oxygenDeveloper.tar.gz";
          sha256 = "sha256-eUyGX9n3OeGB9s1uZ0D4LATnmV4PPYUamp8WaZHyDbY=";
        };

        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p "$out/opt" "$out/bin"
          tar xzf "$src" -C "$out/opt"

          ln -s "$out/opt/oxygenDeveloper/oxygenDeveloper.sh" "$out/bin/xmldev"
        '';

        # nativeBuildInputs = with pkgs; [
        #   cmake
        # ];
      };
  };
}
