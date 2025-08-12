{pkgs, ...}: {
  home.packages = with pkgs; [
    containerd
    cri-o
    docker
    docker-compose
    docker-compose-language-service
    docker-language-server
    dockerfmt
    docui
    flintlock
    lazydocker
    nerdctl
    nvidia-docker
    youki
  ];
}
