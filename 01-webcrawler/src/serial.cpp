#include <stdio.h>
#include <unistd.h>

#include <fstream>
#include <string>
#include <vector>
 
#include "net.h"

#include <iostream>

struct link_data {
  std::string url;  // URL of the link (e.g., articles/p/l/a/Plant.html)
  int depth;        // depth of the link (e.g., 0 for the root page)
};


std::vector<link_data> crawl(std::string url, int depth) {
  std::vector<link_data> links;

  std::string response = socket_send(url);
  std::cout << response << "******YURRR******" << std::endl;

  std::string startOfLink = "<a href=\"";
  std::string currStart= "";

  std::string startOfWiki = "articles/";
  std::string currLink = "";

  //std::cout << startOfLink.length() << " " + startOfLink + "*" << std::endl;
  

  for (size_t i = 0; i < response.length(); i++){
    if (response[i] == '<') {
      for (size_t j = 0; j < startOfLink.length(); j++){
        currStart += response[i + j];
      }
      //std::cout << currStart << "*****" << std::endl;
      if (currStart == startOfLink){
        std::cout << currStart << std::endl;
        size_t linkIdx = 10;
        while(response[i + linkIdx] == '.'  || response[i + linkIdx] == '/') {
          linkIdx += 1;
        }
        while(currLink.length() < startOfWiki.length()){
          currLink += response[i + linkIdx];
          std::cout << currLink << std::endl;
          linkIdx += 1;
        }
        std::cout << currLink << std::endl;
        if (currLink == startOfWiki){
          char quote = '\"';
          while(response[i + linkIdx] != quote) {
            currLink += response[i + linkIdx];
            linkIdx += 1;
          }
          std::cout << currLink << std::endl;
          link_data data;
          data.url = currLink;
          data.depth = 0;
          links.push_back(data);
        }
      }
      currLink = "";
      currStart= "";
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
    out << link.url << "********" << std::endl;
    length += 1;

  }
  std::cout << "length of links: " << length << std::endl;
  out.close();

  
  std::cout << "finsished" << std::endl;
  return 0;
}
