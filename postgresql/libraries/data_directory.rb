def data_directory
  node.postgresql[:data_directory] ||
    "/var/lib/postgresql/#{node.postgresql.version}/main"
end
