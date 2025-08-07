{ services, ... }:
{
  services.ollama = {
    enable = true;

    # Run Ollama as its own user
    user = "ollama";
    group = "ollama";

    # Host on all interfaces so others can access it
    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;

    # Store Ollama models and config in a custom location
    home = "/store/AI/Apps/ollama";

    # Use CUDA (NVIDIA GPU acceleration)
    acceleration = "cuda";

    # Pre-pull this model and load it on startup
    models = [ "gpt-oss:20b" ];
    loadModels = true;

    # Optional: additional environment variables
    environmentVariables = {
      OLLAMA_LOG_LEVEL = "info";  # or "debug"
    };
  };

  # Optional: Create the ollama user/group and ensure the directory exists
  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    home = "/store/AI/Apps/ollama";
    createHome = true;
  };

  users.groups.ollama = {};

  # Optional: make sure the user has GPU access
  # (assuming you're using the `video` or `render` group for your GPU)
  users.users.ollama.extraGroups = [ "video" "render" ];
}

