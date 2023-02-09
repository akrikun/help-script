#!/bin/bash

current_date=$(date +%s)

cutoff_time=$((current_date - 2 * 24 * 60 * 60))

images=$(docker images -q)

for image in $images; do
  create_timestamp=$(docker inspect --format='{{.Created}}' "$image")

  create_time=$(date -d "$create_timestamp" +%s)

  image_name=$(docker inspect --format='{{.RepoTags}}' "$image" | awk -F '/' '{print $2}')
  if [[ "$image_name" == *"frontend"* ]] || [[ "$image_name" == *"ms"* ]]; then
    if [ "$create_time" -lt "$cutoff_time" ]; then
      docker image rm -f "$image"
    fi
  fi
done