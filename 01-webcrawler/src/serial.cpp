#include <stdio.h>
#include <unistd.h>

#include <fstream>
#include <string>
#include <vector>
#include <queue>
 
#include "net.h"

#include <iostream>

struct link_data {
  std::string url;  // URL of the link (e.g., articles/p/l/a/Plant.html)
  int depth;        // depth of the link (e.g., 0 for the root page)
};


std::vector<link_data> crawl(std::string url, int depth) {
  std::vector<link_data> links;
  std::queue<link_data> queue;

  std::string response = socket_send(url);

  std::string href = "<a href=\"";
  std::string startOfLink = "articles/";

  link_data head;
  head.url = url;
  head.depth = 0;
  queue.push(head);

  while(!queue.empty()) {

    
    link_data data = queue.front();

    queue.pop();
    bool original = true;

    for (link_data link: links) {
      if (data.url == link.url) {
        original = false;
      }
    }

    links.push_back(data);

    if (original == true && data.depth == depth) {
      original = false;
    }

    if (original) {
      size_t idx = 0;
      while (idx < response.length()){
        if (response[idx] == '<') {
          size_t linkIdx = 0;
          std::string currHref= "";
          while (linkIdx < href.length()){
            currHref += response[idx + linkIdx];
            linkIdx += 1;
          }
          if (currHref == href){
            while(response[idx + linkIdx] == '.'  || response[idx + linkIdx] == '/') {
              linkIdx += 1;
            }
            std::string currLink = "";
            while(currLink.length() < startOfLink.length()){
              currLink += response[idx + linkIdx];
              linkIdx += 1;
            }
            if (currLink == startOfLink){
              while(response[idx + linkIdx] != '\"') {
                currLink += response[idx + linkIdx];
                linkIdx += 1;
              }
              link_data innerLink;
              innerLink.url = currLink;
              innerLink.depth = data.depth + 1;
              queue.push(innerLink);
            }
            idx = linkIdx + idx;
          }
        }
        idx += 1;
      }
    }
  }



  
  // TODO: implement
  // remove the following lines (these prevent a compiler warning)
  //(void)url;
  //(void)depth;
  // end of TODO

  return links;
}

int main(int argc, char* argv[]) {
  // For argument parsing
  std::cout << "here" << std::endl;
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
  int length = 0;
  for (link_data link : links) {
    out << link.url << std::endl;
    length += 1;

  }
  std::cout << "length of links: " << length << std::endl;
  out.close();

  
  std::cout << "finsished" << std::endl;
  return 0;
}