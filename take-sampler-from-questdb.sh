#!/bin/bash

# Function to execute SQL query
execute_query() {
  local query=$1
  curl -G --data-urlencode "query=${query}" http://localhost:9000/exec
}

# List all tables
tables=$(execute_query "SHOW TABLES;" | jq -r '.dataset[][]')

# Loop through each table and extract headers and first 5 rows
for table in $tables; do
  query="SELECT * FROM ${table} LIMIT 5;"
  response=$(execute_query "$query")
  columns=$(echo "$response" | jq -c '.columns')
  dataset=$(echo "$response" | jq -c '.dataset')
  count=$(echo "$response" | jq -r '.count')

  output=$(jq -n --arg query "$query" --argjson columns "$columns" --argjson dataset "$dataset" --arg count "$count" \
    '{query: $query, columns: $columns, timestamp: -1, dataset: $dataset, count: $count}')

  echo "$output" >> aaa
done
