#include <stdio.h>
#include <unistd.h>

#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <queue>
#include <thread>
#include <mutex>

#include "net.h"

struct link_data {
  std::string url;  // URL of the link (e.g., articles/p/l/a/Plant.html)
  int depth;        // depth of the link (e.g., 0 for the root page)
};

bool not_busy(std::vector<bool> &busy){
  bool answer = true;
  for (bool t : busy) {
    if (t) {
      answer = false;
    }
  }
  return answer;
}


void crawlHelper(std::queue<link_data> &queue, std::vector<link_data> &links, std::vector<bool> &busy, std::mutex& q_mutex, int id, int depth) {

  std::string href = "<a href=\"";
  std::string startOfLink = "articles/";

  bool running = true;

  while(running) {
    std::cout << queue.size() << std::endl;
    std::cout << id << std::endl;
    q_mutex.lock();
    if (queue.empty() && not_busy(busy)) {
      q_mutex.unlock();
      running = false;
      break;
    } else if (!queue.empty()) {
      while(!queue.empty()) {
        link_data data = queue.front();
        queue.pop();
        busy[id] = true;q_mutex.lock();
        q_mutex.unlock();
        bool original = true;

        for (link_data link: links) {
          if (data.url == link.url) {
            original = false;
          }
        }

        if(original) {
          q_mutex.lock();
          links.push_back(data);
          q_mutex.unlock();
          //std::cout << links.size() << std::endl;
        }

        if (original && data.depth < depth) {
          std::string response = socket_send(data.url);
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
                  q_mutex.lock();
                  queue.push(innerLink);
                  q_mutex.unlock();
                }
                idx = linkIdx + idx;
              }
            }
            idx += 1;
          }
        }

      }
      busy[id] = false;
    } else {
      q_mutex.unlock();
    }
  }

}




std::vector<link_data> crawl(std::string url, int depth, int threads) {
  std::vector<link_data> links;
  std::queue<link_data> queue;
  std::mutex q_mutex;
  std::vector<bool> busy(threads, false);
  std::vector<std::thread> threads_v;

  link_data head;
  head.url = url;
  head.depth = 0;
  queue.push(head);

  for(int i = 0; i < threads; i++) {
    int id = i;
    std::thread t(crawlHelper, std::ref(queue), std::ref(links), std::ref(busy), std::ref(q_mutex), id, depth);
    threads_v.push_back(std::move(t));
  }

  for (auto &t : threads_v) {
    t.join();
  }

  
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
  int threads = 1;

  // Parse arguments
  while ((opt = getopt(argc, argv, "u:d:o:t:")) != -1) {
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
      case 't':
        threads = std::atoi(optarg);
        break;
      default:
        fprintf(stderr,
                "Usage: %s -u <url> -d <depth> -t <num_threads> -o "
                "<output_path>\n",
                argv[0]);
    };
  }

  if (!uflag && !oflag) {
    fprintf(stderr,
            "Usage: %s -u <url> -d <depth> -t <num_threads> -o <output_path>\n",
            argv[0]);
    return 1;
  }



  std::vector<link_data> links = crawl(url, depth, threads);

  // write links to an output file
  std::ofstream out(output_path);
  for (link_data link : links) {
    out << link.url << std::endl;
  }
  out.close();

  return 0;
}
