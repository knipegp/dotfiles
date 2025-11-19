# Auto-generated using compose2nix v0.3.2-pre.
{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
{
  options.services.khoj-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Khoj virtual host";
    };
  };
  config = {
    # Runtime
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };
    virtualisation.oci-containers.backend = "docker";

    # Containers
    virtualisation.oci-containers.containers."khoj-database" = {
      image = "docker.io/pgvector/pgvector:pg15";
      environment = {
        "POSTGRES_DB" = "postgres";
        "POSTGRES_PASSWORD" = "postgres";
        "POSTGRES_USER" = "postgres";
      };
      volumes = [ "khoj_khoj_db:/var/lib/postgresql/data:rw" ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=pg_isready -U postgres"
        "--health-interval=30s"
        "--health-retries=5"
        "--health-timeout=10s"
        "--network-alias=database"
        "--network=khoj_default"
      ];
    };
    systemd.services."docker-khoj-database" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "docker-network-khoj_default.service"
        "docker-volume-khoj_khoj_db.service"
      ];
      requires = [
        "docker-network-khoj_default.service"
        "docker-volume-khoj_khoj_db.service"
      ];
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };
    virtualisation.oci-containers.containers."khoj-sandbox" = {
      image = "ghcr.io/khoj-ai/terrarium:latest";
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=curl -f http://localhost:8080/health"
        "--health-interval=30s"
        "--health-retries=2"
        "--health-timeout=10s"
        "--network-alias=sandbox"
        "--network=khoj_default"
      ];
    };
    systemd.services."docker-khoj-sandbox" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [ "docker-network-khoj_default.service" ];
      requires = [ "docker-network-khoj_default.service" ];
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };
    virtualisation.oci-containers.containers."khoj-search" = {
      image = "docker.io/searxng/searxng:latest";
      environment = {
        "SEARXNG_BASE_URL" = "http://localhost:8080/";
      };
      volumes = [ "khoj_khoj_search:/etc/searxng:rw" ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=search"
        "--network=khoj_default"
      ];
    };
    systemd.services."docker-khoj-search" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "docker-network-khoj_default.service"
        "docker-volume-khoj_khoj_search.service"
      ];
      requires = [
        "docker-network-khoj_default.service"
        "docker-volume-khoj_khoj_search.service"
      ];
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };
    virtualisation.oci-containers.containers."khoj-server" = {
      image = "ghcr.io/khoj-ai/khoj:latest";
      environment = {
        "KHOJ_ADMIN_EMAIL" = "username@example.com";
        "KHOJ_ADMIN_PASSWORD" = "password";
        "KHOJ_DEBUG" = "False";
        "KHOJ_DJANGO_SECRET_KEY" = "secret";
        "KHOJ_SEARXNG_URL" = "http://search:8080";
        "OPENAI_BASE_URL" = "http://ollama:11434/v1/";
        "KHOJ_TERRARIUM_URL" = "http://sandbox:8080";
        "POSTGRES_DB" = "postgres";
        "POSTGRES_HOST" = "database";
        "POSTGRES_PASSWORD" = "postgres";
        "POSTGRES_PORT" = "5432";
        "POSTGRES_USER" = "postgres";
      };
      volumes = [
        "khoj_khoj_config:/root/.khoj:rw"
        "khoj_khoj_models:/root/.cache/huggingface:rw"
      ];
      ports = [ "127.0.0.1:42110:42110/tcp" ];
      cmd = [
        "--host=0.0.0.0"
        "--port=42110"
        "-vv"
        "--anonymous-mode"
        "--non-interactive"
      ];
      dependsOn = [ "khoj-database" ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=server"
        "--network=khoj_default"
      ];
    };
    systemd.services."docker-khoj-server" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "docker-network-khoj_default.service"
        "docker-volume-khoj_khoj_config.service"
        "docker-volume-khoj_khoj_models.service"
        "docker-volume-khoj_khoj_models.service"
        "docker-ollama.service"
      ];
      requires = [
        "docker-network-khoj_default.service"
        "docker-volume-khoj_khoj_config.service"
        "docker-volume-khoj_khoj_models.service"
        "docker-volume-khoj_khoj_models.service"
        "docker-ollama.service"
      ];
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };

    # Networks
    systemd.services."docker-network-khoj_default" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "docker network rm -f khoj_default";
      };
      script = ''
        docker network inspect khoj_default || docker network create khoj_default
      '';
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };

    # Volumes
    systemd.services."docker-volume-khoj_khoj_config" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        docker volume inspect khoj_khoj_config || docker volume create khoj_khoj_config
      '';
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };
    systemd.services."docker-volume-khoj_khoj_db" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        docker volume inspect khoj_khoj_db || docker volume create khoj_khoj_db
      '';
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };
    systemd.services."docker-volume-khoj_khoj_models" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        docker volume inspect khoj_khoj_models || docker volume create khoj_khoj_models
      '';
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };
    systemd.services."docker-volume-khoj_khoj_search" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        docker volume inspect khoj_khoj_search || docker volume create khoj_khoj_search
      '';
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."docker-compose-khoj-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
    virtualisation.oci-containers.containers."ollama" = {
      image = "docker.io/ollama/ollama:rocm";
      environment = {
        HCC_AMDGPU_TARGET = "gfx1032";
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";
        OLLAMA_HOST = "0.0.0.0";
      };
      devices = [
        "/dev/dri:/dev/dri"
        "/dev/kfd:/dev/kfd"
      ];
      volumes = [ "ollama:/root/.ollama" ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=ollama"
        "--network=khoj_default"
      ];
    };
    systemd.services."docker-ollama" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [ "docker-network-khoj_default.service" ];
      requires = [ "docker-network-khoj_default.service" ];
      partOf = [ "docker-compose-khoj-root.target" ];
      wantedBy = [ "docker-compose-khoj-root.target" ];
    };

    # services.ollama = {
    #   enable = true;
    #   acceleration = "rocm";
    #   host = "0.0.0.0";
    #   environmentVariables = {
    #     HCC_AMDGPU_TARGET = "gfx1032";
    #     HSA_OVERRIDE_GFX_VERSION = "10.3.0";
    #   };
    #   loadModels = [
    #     # "olmo2:7b"
    #     "smollm2:135m"
    #   ];
    # };
    # Enable nginx and configure reverse proxy
    services.nginx.virtualHosts."khoj.${config.services.khoj-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:42110";
        proxyWebsockets = true;
      };
    };
  };
}
