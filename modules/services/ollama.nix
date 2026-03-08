{ config, pkgs, ... }: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    host = "0.0.0.0";
    port = 11434;
    home = "/var/lib/ollama";
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "24h";
      OLLAMA_MAX_LOADED_MODELS = "2";
    };
  };

  services.open-webui = {
    enable = true;
    port = 8080;
    host = "0.0.0.0";
    environment = {
      OLLAMA_BASE_URL = "http://localhost:11434";
      WEBUI_AUTH = "false";
    };
  };
}
