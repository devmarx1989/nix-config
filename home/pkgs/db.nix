{
  home,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    dolt
    litecli
    meilisearch
    mycli
    pgcli
    qdrant
    qdrant-web-ui
    surrealdb
    surrealist
    weaviate
  ];
}
