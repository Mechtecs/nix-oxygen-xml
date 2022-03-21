{
  description = "Package the hello repeater.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.oxygen-xml-developer_22_1 =
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
        java = pkgs.openjdk11;
      in
      pkgs.stdenv.mkDerivation rec {
        pname = "oxygen-xml-developer";
        version = "22.1";

        src = pkgs.fetchurl {
          url = "https://archives.oxygenxml.com/Oxygen/Developer/InstData${version}/All/oxygenDeveloper.tar.gz";
          sha256 = "sha256-eUyGX9n3OeGB9s1uZ0D4LATnmV4PPYUamp8WaZHyDbY=";
        };

        desktopItems = with pkgs; [
          (makeDesktopItem {
            name = "${pname}";
            desktopName = "Oxygen XML Developer ${version}";
            icon = "Developer128";
            categories = [ "Development" ];
            exec = "xmldev %F";
          })
        ];

        nativeBuildInputs = with pkgs; [
          copyDesktopItems
          makeWrapper
        ];

        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p "$out/opt" "$out/bin" "$out/share/icons/hicolor/128x128/apps"
          tar xzf "$src" -C "$out/opt"

          cp "$out/opt/oxygenDeveloper/Developer128.png" "$out/share/icons/hicolor/128x128/apps"
          
          makeWrapper "$out/opt/oxygenDeveloper/oxygenDeveloper.sh" $out/bin/xmldev \
            --set JAVA_HOME ${java.home}
        '';
      };
  };
}
