{
  services,
  config,
  ...
}: let
  ports = config.my.ports;
  grpc = ports.lokiGrpc;
  http = ports.lokiHttp;
in {
  #####################
  # Loki (server)
  #####################
  services.loki = {
    enable = true;
    user = "loki";
    group = "loki";
    dataDir = "/store/loki";

    configuration = {
      common = {
        path_prefix = "${config.services.loki.dataDir}";
        ring = {
          kvstore = {store = "inmemory";};
          instance_addr = "127.0.0.1";
        };
        replication_factor = 1;
      };
      server = {
        http_listen_port = http;
        grpc_listen_port = grpc;
      };

      schema_config = {
        configs = [
          {
            from = "2020-10-24";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      storage_config = {
        filesystem.directory = "${config.services.loki.dataDir}/chunks";
      };

      limits_config = {
        allow_structured_metadata = true;
        ingestion_burst_size_mb = 16;
        ingestion_rate_mb = 8;
        max_query_series = 500000;
        retention_period = "168h";
      };

      compactor = {
        working_directory = "${config.services.loki.dataDir}/compactor";
        compaction_interval = "5m";
        delete_request_cancel_period = "48h";
        delete_request_store = "filesystem";
        retention_enabled = true;
      };

      ruler = {storage = {type = "local";};};
    };
  };
}
