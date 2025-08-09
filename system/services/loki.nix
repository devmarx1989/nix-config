{services, config, ...}:
{
 #####################
  # Loki (server)
  #####################
  services.loki = {
    enable = true;
    user = "loki";
    group = "loki";
    dataDir = "/store/loki";

    configuration = {
      server = {
        http_listen_port = 1030;
        grpc_listen_port = 1031;
      };

      schema_config = {
        configs = [{
          from = "2020-10-24";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "v13";
          index = { prefix = "index_"; period = "24h"; };
        }];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "${config.services.loki.dataDir}/index";
          cache_location         = "${config.services.loki.dataDir}/boltdb-cache";
          shared_store           = "filesystem";
        };
        filesystem.directory = "${config.services.loki.dataDir}/chunks";
      };

      limits_config = {
        retention_period = "168h";
        ingestion_rate_mb = 8;
        ingestion_burst_size_mb = 16;
      };

      table_manager = {
        retention_deletes_enabled = true;
        retention_period = "168h";
      };

      compactor = {
        working_directory = "${config.services.loki.dataDir}/compactor";
        compaction_interval = "5m";
        delete_request_cancel_period = "24h";
        retention_enabled = true;
      };
    };
  };
}
