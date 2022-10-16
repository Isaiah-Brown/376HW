#include <iostream>
#include <omp.h>

#include "image.h"

int main(int argc, char **argv) {
  if (argc != 4) {
    std::cerr << "Usage: " << argv[0] << " <input> <output> <scale_factor>"
              << std::endl;
    return 1;
  }

  int scale = atoi(argv[3]);
  Image img(argv[1]);

  int w = img.w;
  int h = img.h;

  Image out_img(w * scale, h * scale);
  

#pragma omp parallel for
{
  for(int i = 0; i < w; i++) {
    int p;
    int x;
    int y;
    for(int j = 0; j < h; j++){
      p = img.get(i, j);
      for(int k =0; k < scale; k++){
        for(int l = 0; l < scale; l++) {
          x = (i * scale) + k;
          y = (j * scale) + l;
          out_img.set(x, y, p);
        }
      }
    }
  }
}

  out_img.write(argv[2]);

  return 0;
}
