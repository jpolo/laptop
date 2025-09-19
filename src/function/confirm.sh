#!/usr/bin/env bash

# Confirm
#
# Example 1 :
#   laptop_confirm Delete file1? && echo rm file1
#
# Example 2 :
#   laptop_confirm Delete file2?
#   if [ $? -eq 0 ]
#
laptop_confirm() {
  # If LAPTOP_YES is true, skip confirmation and return success
  if [ "$LAPTOP_YES" = "true" ]; then
    return 0
  fi

  echo -n "$* "
  read -e -r answer
  for response in y Y yes YES Yes Sure sure SURE OK ok Ok; do
    if [ "_$answer" == "_$response" ]; then
      return 0
    fi
  done
  # Any answer other than the list above is considerred a "no" answer
  return 1
}
