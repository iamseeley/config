{ inputs, config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/services/ollama.nix
  ];

  networking.hostName = "llm-box";
  networking.useDHCP = true;

  nixpkgs.config.allowUnfree = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    cuda.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    cudatoolkit
    cudnn
    nvtopPackages.nvidia
    git-lfs
    ollama
  ];

  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.cudatoolkit
      pkgs.cudnn
      "/run/opengl-driver"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 22 11434 8080 ];

  home-manager.users.tseeley.imports = [
    ../../home/dev.nix
    ../../home/tmux.nix
  ];

  system.stateVersion = "24.11";
}
