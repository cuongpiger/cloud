# Thiết lập môi trường
* Source code chạy trên hệ điều hành Ubuntu 20.04 LTS và chạy trên môi trường Anaconda, thiết lập chi tiết như sau:
  ```shell
  # tạo môi trường python mới có tên là tensor2x 
  conda create --name tensor2x python=3.6.8 pip
  conda activate tensor2x

  # cài đặt các python package cần thiết
  # (nếu máy có cuDNN driver và NVIDIA GPU)
  conda install tensorflow-gpu==2.0.0     
  # LƯU Ý: trong trường hợp máy không có NVIDIA DRIVER hoặc chưa kích hoạt cuDNN driver thì chạy lệnh này thay lệnh bên trên
  conda install tensorflow==2.0.0

  pip install keras==2.3.0
  conda install -c conda-forge pydot graphviz  
  pip install numpy matplotlib
  ```