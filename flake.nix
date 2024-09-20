{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = system; config.allowUnfree = true; };
    in
    {
      devShells.${system}.default = pkgs.mkShell
        {
          name = "cuda-env-shell";
          buildInputs = with pkgs; [
            git
            gitRepo
            gnupg
            autoconf
            curl
            procps
            gnumake
            utillinux
            m4
            gperf
            unzip
            cmake
            cudatoolkit
            linuxPackages.nvidia_x11
            libGLU
            libGL
            cudaPackages.cuda_cudart
            xorg.libXi
            xorg.libXmu
            freeglut
            xorg.libXext
            xorg.libX11
            xorg.libXv
            xorg.libXrandr
            zlib
            pngpp
            tbb
            xorg.libX11
            xorg.libXtst

            ncurses5
            stdenv.cc
            binutils
            doxygen
            gbenchmark
            feh
            cudaPackages.cuda_nvprof
          ];
          shellHook = ''
            export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
            export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:${pkgs.libkrb5}/lib:$LD_LIBRARY_PATH
            export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib $EXTRA_LDFLAGS"
            export EXTRA_CCFLAGS="-I/usr/include $EXTRA_CCFLAGS"
            export LD_LIBRARY_PATH=${pkgs.cudaPackages.cuda_nvprof.lib}/lib:$LD_LIBRARY_PATH
          '';

        };
    };
}
