#include <stdio.h>
#include <unistd.h>

#include <fstream>
#include <string>
#include <vector>

#include "net.h"

struct link_data {
  std::string url;  // URL of the link (e.g., articles/p/l/a/Plant.html)
  int depth;        // depth of the link (e.g., 0 for the root page)
};

std::vector<link_data> crawl(std::string url, int depth) {
  std::vector<link_data> links;
  // TODO: implement
  // remove the following lines (these prevent a compiler warning)
  (void)url;
  (void)depth;
  // end of TODO

  return links;
}

int main(int argc, char* argv[]) {
  // For argument parsing
  extern char* optarg;
  int opt;
  bool uflag = false, oflag = false;

  // Holds variables from arguments
  std::string url;
  std::string output_path;
  int depth = 0;

  // Parse arguments
  while ((opt = getopt(argc, argv, "u:d:o:")) != -1) {
    switch (opt) {
      case 'u':
        uflag = true;
        url = std::string(optarg);
        break;
      case 'd':
        depth = std::atoi(optarg);
        break;
      case 'o':
        uflag = true;
        output_path = std::string(optarg);
        break;
      default:
        fprintf(stderr, "Usage: %s -u <url> -d <depth> -o <output_path>\n",
                argv[0]);
    };
  }

  if (!uflag && !oflag) {
    fprintf(stderr, "Usage: %s -u <url> -d <depth> -o <output_path>\n",
            argv[0]);
    return 1;
  }

  std::vector<link_data> links = crawl(url, depth);

  // write links to an output file
  std::ofstream out(output_path);
  for (link_data link : links) {
    out << link.url << std::endl;
  }
  out.close();

  return 0;
}
