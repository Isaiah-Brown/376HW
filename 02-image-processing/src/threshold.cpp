#include <iostream>
#include <omp.h>

#include "image.h"

int main(int argc, char **argv) {
  
  if (argc != 3) {
    std::cerr << "Usage: " << argv[0] << " <input> <output>" << std::endl;
    return 1;
  }

  Image img(argv[1]);    // This reads the image into the Image object
  int w = img.w;
  int h = img.h;
  int t = 0;
  int p;

 
#pragma omp parallel for reduction(+:t)
{
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      t += img.get(i, j);
    }
  }
}
  t = t / (w * h);
  Image out_img(w, h); // Creates an output image (img.w x img.h)

#pragma omp parallel for
{
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      p = img.get(i, j);
      if (p < t) {
        out_img.set(i, j, 0);
      } else {
        out_img.set(i, j, 255);
      }
    }
  }
}

  // TODO: find the threshold (average of the image using OpenMP)


  // TODO: threshold the image (using OpenMP)

  out_img.write(argv[2]); // This writes the output image to a file

  return 0;
}
