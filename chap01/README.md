# Chapter 01. Getting Started
---

# 1. Installation
* To install Vim from the GitHub repo, do the following;
  ```bash=
  git clone https://github.com/vim/vim.git
  cd vim/src
  make
  sudo make install
  ```

* By default, Vim does not enable Python plugins, to enable it, do the following
  ```bash=
  git clone https://github.com/vim/vim.git
  cd vim/src
  ./configure --with-features=huge --enable-python3interp
  make distclean
  make
  sudo make install
  ```

# 2. Common operations
