{
   description = "Automation Programming Game";

   inputs = {
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
   };

   outputs = { self, nixpkgs }: let
      supportedSystems = [ "x86_64-linux" "aarch64-linux"  "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = (fun:
         ((nixpkgs.lib.genAttrs supportedSystems) (system:
            let pkgs = nixpkgs.legacyPackages.${system};
               in fun {
                  system = system;
                  pkgs = pkgs;
                  libs = with pkgs; [
                     # Dependencies
                     raylib
                  ];
                  buildTools = with pkgs; [
                     cmake
                     ninja
                  ];
               }
         ))
      );
   in {
      devShells = forAllSystems ({ system, pkgs, libs, buildTools }: {
         automation-programming-game = pkgs.clangStdenv.mkDerivation {
            name = "automation-programming-game";

            nativeBuildInputs = with pkgs; [
               clang-tools
            ] ++ buildTools;
            buildInputs = libs;

            shellHook = ''
               exec zsh;
            '';
         };
         default = self.devShells.${system}.automation-programming-game;
      });
      checks = forAllSystems ({ system, pkgs, libs, buildTools }: {
         format = pkgs.clangStdenv.mkDerivation {
            name = "automation-programming-game-format";

            nativeBuildInputs = with pkgs; [
               clang-tools
            ] ++ buildTools;

            src = ./.;
            buildPhase = ''
               ${pkgs.gnumake}/bin/make check-fmt
            '';
            installPhase = ''
               mkdir -p $out
            '';
         };
         lint = pkgs.clangStdenv.mkDerivation {
            name = "automation-programming-game-lint";

            nativeBuildInputs = with pkgs; [
               clang-tools
            ] ++ buildTools;

            src = ./.;
            buildPhase = ''
               ${pkgs.gnumake}/bin/make check-lint
            '';
            installPhase = ''
               mkdir -p $out
            '';
         };
      });
      packages = forAllSystems ({ system, pkgs, libs, buildTools }: {
         automation-programming-game = pkgs.clangStdenv.mkDerivation {
            name = "automation-programming-game";
            version = "0.1.0";

            nativeBuildInputs = buildTools;
            buildInputs = libs;

            CPATH = pkgs.lib.makeSearchPathOutput "dev" "include" (libs ++ [ pkgs.glibc ]);

            src = ./.;
            buildPhase = ''
               ${pkgs.gnumake}/bin/make auto
            '';
            installPhase = ''
               mkdir -p $out/bin
               cp pf $out/bin/
               chmod 755 $out/bin/auto
            '';
         };
         default = self.packages.${system}.automation-programming-game;
      });
      apps = forAllSystems ({ system, pkgs, libs }: {
         automation-programming-game = {
            type = "app";
            program = "${self.packages.${system}.automation-programming-game}/bin/auto";
         };
         default = self.apps.${system}.automation-programming-game;
      });
   };
}
