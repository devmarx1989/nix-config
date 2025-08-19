{
  config,
  pkgs,
  services,
  lib,
  ...
}: let
  ports = config.my.ports;
  ollamaPort = ports.ollama;
in {
  services.ollama = {
    enable = true;

    # Run Ollama as its own user
    user = "ollama";
    group = "ollama";

    # Host on all interfaces so others can access it
    host = "0.0.0.0";
    port = ollamaPort;
    openFirewall = true;

    # Store Ollama models and config in a custom location
    home = "/drive/ollama";
    models = "/drive/ollama/models";

    # Use CUDA (NVIDIA GPU acceleration)
    acceleration = "cuda";

    # Pre-pull this model and load it on startup
    loadModels = [
      "cogito:14b"
      "cogito:3b"
      "cogito:8b"
      "command-r7b-arabic:7b"
      "deepcoder:1.5b"
      "deepcoder:14b"
      "deepseek-r1:1.5b"
      "deepseek-r1:14b"
      "deepseek-r1:7b"
      "deepseek-r1:8b"
      "devstral:24b"
      "exaone-deep:2.4b"
      "exaone-deep:7.8b"
      "gemma3:12b"
      "gemma3:1b"
      "gemma3:4b"
      "gemma3n:e2b"
      "gemma3n:e4b"
      "gpt-oss:20b"
      "granite3.2-vision:2b"
      "granite3.3:2b"
      "granite3.3:8b"
      "llama3.1:8b"
      "magistral:24b"
      "mistral-small3.2:24b"
      "nomic-embed-text:v1.5"
      "olmo2:13b"
      "olmo2:7b"
      "phi3:14b"
      "phi3:3.8b"
      "phi4-mini-reasoning:3.8b"
      "phi4-mini:3.8b"
      "phi4-reasoning:14b"
      "phi4:14b"
      "qwen2.5-coder:0.5b"
      "qwen2.5-coder:1.5b"
      "qwen2.5-coder:14b"
      "qwen2.5-coder:3b"
      "qwen2.5-coder:7b"
      "qwen2.5vl:3b"
      "qwen2.5vl:7b"
      "qwen3-coder:30b"
      "qwen3:0.6b"
      "qwen3:1.7b"
      "qwen3:14b"
      "qwen3:4b"
      "qwen3:8b"
    ];

    # Optional: additional environment variables
    environmentVariables = {
      OLLAMA_LOG_LEVEL = "info"; # or "debug"
    };
  };

  users.groups.ollama = {};
  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    extraGroups = ["video" "render"];
    home = "/drive/ollama";
    createHome = true;
  };

  # Belt-and-suspenders: if something elsewhere overrides the unit, force ExecStart.
  systemd.services.ollama.serviceConfig.ExecStart =
    lib.mkForce "${pkgs.ollama}/bin/ollama serve";

  systemd.services.ollama.unitConfig.RequiresMountsFor = ["/drive/ollama"];

  systemd.tmpfiles.rules = [
    "d /drive/ollama         0777 ollama ollama -"
    "d /drive/ollama/.ollama 0777 ollama ollama -"
    "d /drive/ollama/models  0777 ollama ollama -"
  ];
}
