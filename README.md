[↩ Back to `main` branch](https://github.com/cuongpiger/cloud)

###### Brief
- My little demo for user defined module in Ansible.

###### References
- [https://auscunningham.medium.com/write-a-ansible-module-with-python-527f0b292b4d](https://auscunningham.medium.com/write-a-ansible-module-with-python-527f0b292b4d)

<hr>

# 1. Instructions
## 1.1. Hello World demo

- Create the virtual environment:
  ```bash=
  conda create -n ansible-hello-world python=3.8 pip
  ```

- Activate the virtual environment:
  ```bash=
  conda activate ansible-hello-world && \
  pip install -r requirements.txt
  ```

- Run the playbook:
  ```bash=
  ansible-playbook hello-world.yml
  ```
  ![](./img/01.png)

## 1.2. Pass arguments to the module
- Run the playbook:
  ```bash=
  ansible-playbook version_change.yml
  ```
  ![](./img/02.png)