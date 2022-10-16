#include <iostream>
#include <omp.h>
#include <time.h>

#include "image.h"

int main(int argc, char **argv) {
  if (argc != 5) {
    std::cerr << "Usage: " << argv[0]
              << " <input> <output> <num_threads> <blur_size>" << std::endl;
    return 1;
  }

  int num_threads = atoi(argv[3]);
  int blur_size = atoi(argv[4]);


  Image img(argv[1]);
  int w = img.w;
  int h = img.h;
  Image out_img(w, h);

  
  omp_set_num_threads(num_threads);
#pragma omp parallel for
{
  for(int i = 0; i < w; i++) {
    int blurred_p = 0;
    int blur_box_count = 0;
    int blur_i;
    int blur_j;
    for(int j = 0; j < h; j++){
      for(int k = 0; k < blur_size; k++){
        blur_i = k + i - (blur_size/2);
        for(int l = 0; l < blur_size; l++) {
          blur_j = l + j - (blur_size/2);
          if ((blur_i > -1 && blur_i < w) && (blur_j > -1 && blur_j < h)) {
            blurred_p += img.get(blur_i, blur_j);
            blur_box_count += 1;
          }
        }
      }
      blurred_p = blurred_p / blur_box_count;
      out_img.set(i, j, blurred_p);
      blur_box_count = 0;
      blurred_p = 0;
    }
  }
}
 


  out_img.write(argv[2]);

  // TODO: blur the image using a blur_size x blur_size filter (using OpenMP)

  return 0;
}
