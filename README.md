directory-make
==============

A role that ensures some directories exist and have the right permission.

Each directory is  described as follows:

    - group: The name of the group the directory should belong to  (default: dirmake\_group)
      mode: The mode the directory should have                     (default: 0700)
      owner: The name of the user that should own the directory    (default: dirmake\_user)
      path: Path of the directory you need to ensure exists        (no default, mandatory)
      

Requirements
------------

This role has no requirements.


Role Variables
--------------

All variables in this roles are namespaced with the prefix `dirmake_`.

- `dirmake_directories`: the list of directories to check, specified by items as specified above (default: [])
- `dirmake_group`: the default group the directories should belong to (default: omit, meaning will be determined by the system)
- `dirmake_mode`: the default mode the directories should have (default: 0700)
- `dirmake_owner`: the default owner for the directories (default: remote\_user)


Dependencies
------------

This role has no dependencies.


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      vars:
        dirmake_directories:
          - path: "/home/user/some/path"
            owner: "alice"
            mode: 0600
          - path: "/home/user/some/other/path"
          - path: "/home/user/yet/another/directory"
            group: "bob"
      roles:
         - role: cans.directory-make


    - hosts: servers
      vars_files:
        - vars/part1.yml   # defines directory_list_1
        - vars/part2.yml   # defines directory_list_2
      roles:
        - role: cans.directory-make
          dirmake_directories: "{{ directory_list_1 + directory_list_2 }}"

License
-------

GPLv2


Author Information
------------------

Copyright © 2017, Nicolas CANIART.
