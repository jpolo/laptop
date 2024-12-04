#!/usr/bin/env bash

# Confirm
#
# Example 1 :
#   laptop::confirm Delete file1? && echo rm file1
#
# Example 2 :
#   laptop::confirm Delete file2?
#   if [ $? -eq 0 ]
#
laptop::confirm() {
  echo -n "$@ "
  read -e -r answer
  for response in y Y yes YES Yes Sure sure SURE OK ok Ok
  do
    if [ "_$answer" == "_$response" ]
    then
      return 0
    fi
  done
  # Any answer other than the list above is considerred a "no" answer
  return 1
}
