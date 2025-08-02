{
  pkgs ? import <nixpkgs> {
  config.allowUnfree = true;
  config.cudaSupport = true;
  config.cudaVersion = 12;
  }
}:
pkgs.dockerTools.buildImage {
  name = "cuda";
  tag = "latest";

  fromImage = pkgs.dockerTools.pullImage {
    imageName = "linuxserver/openssh-server";
    finalImageTag = "version-10.0_p1-r7";
    imageDigest = "sha256:cb432b4720788ee7a4c87c9aab8b79d23337380ede62479cf1e831bb1b2f6f9a";
    sha256 = "54bc10a7aad9f518078e9b21cad75f9673b1b656e6d1dbf01f79bc30f80ad174";
  };

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = with pkgs; [
    git gitRepo gnupg autoconf curl
    procps gnumake util-linux m4 gperf unzip
    cudatoolkit # cudaPackages.cuda_nvcc 
    nvtopPackages.full
    glibc_multi libGLU libGL
    xorg.libXi xorg.libXmu freeglut
    xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
    linuxPackages.nvidia_x11
    zlib ncurses5 stdenv.cc binutils
    ];
    # pathsToLink = [ "/bin" ];
  };

  runAsRoot = ''
    export CUDA_PATH=${pkgs.cudatoolkit}
    export LD_LIBRARY_PATH=/run/opengl-driver/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
    export NIX_LDFLAGS="$NIX_LDFLAGS -L/nix/store/7r9q014pymaibifx57rz1cd8xldcmlaj-cudatoolkit-12.8.0/targets/x86_64-linux/lib"
  '';

  # config = {
  #   Cmd = [ "/bin/redis-server" ];
  #   WorkingDir = "/data";
  #   Volumes = {
  #     "/data" = { };
  #   };
  # };
}
