#!/bin/bash

# Set the output file
output_file=.gitignore

# Create an empty output file
touch $output_file
echo -e "# Ignore all\n*\n\n# Unignore all with extensions\n!*.*\n\n# Unignore all dirs\n!*/" > $output_file

# Define an array of URLs
urls=(
  "https://raw.githubusercontent.com/github/gitignore/main/C++.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/C.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Elixir.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Erlang.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Go.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Haskell.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Java.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Julia.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Lua.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Node.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/OCaml.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Objective-C.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Perl.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/R.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Ruby.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Rust.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Scala.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Swift.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/VisualStudio.gitignore"
  "https://raw.githubusercontent.com/github/gitignore/main/Global/macOS.gitignore"
)

# Iterate over the array of URLs
for url in "${urls[@]}"; do
  # Use curl to download the contents of the URL
  content=$(curl -s "$url")

  echo "downloading $url"
  # Append the content to the output file, preceded by a separator and the URL
  echo "################################################################################" >> $output_file
  echo "# $url" >> $output_file
  echo "$content" >> $output_file
done

echo "Finished downloading and appending content from URLs"
