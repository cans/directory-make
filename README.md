directory-make
==============

A role that ensures some directories exist and have the right permission.

Each directory is  described as follows:

```yaml
- group: "bobcats"       # The name of the group the directory should belong to
  mode: "0755"           # The mode the directory should have
  owner: "alice"         # The name of the user that should own the directory
  path:  "/opt/service"  # Path of the directory you need to ensure exists
```

See the [Role Variables](#role-variables) section for more details.


Requirements
------------

This role has no requirements.


Role Variables
--------------

All variables in this roles are namespaced with the prefix `dirmake_`.

- `dirmake_directories`: the list of directories to check and create or modify,
  described with items as specified above (default: `[]`)
- `dirmake_group`: the default group the directories should belong to.
  (default: omit, meaning will be determined by the system)
- `dirmake_mode`: the default mode the directories should have (default: `"0700"`)
- `dirmake_owner`: the default owner for the directories (default: `remote_user`)


Dependencies
------------

This role has no dependencies.


Example Playbooks
-----------------

Here is a basic example of how to use this roles:

```yaml
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
```

Note that to limit the number of tasks run, or avoid using the same role
twice, you can "bind" the roles with its list of directories to check as
shown hereafter.

```yaml
- hosts: servers
  vars_files:
    - vars/part1.yml   # defines directory_list_1
    - vars/part2.yml   # defines directory_list_2
  roles:
    - role: cans.directory-make
      dirmake_directories: "{{ directory_list_1 + directory_list_2 }}"
```

In the example above the list of directories to create is built from a
two lists that come from two different variable files, but they could also
come for other roles:

```yaml
- hosts: servers
  roles:
    - role: cans.directory-make
      dirmake_directories: "{{ some_service_directory_list + other_service_directory_list }}"
    - role: some-service-setup
    - role: other-service-setup
```


License
-------

GPLv2


Author Information
------------------

Copyright © 2017-2018, Nicolas CANIART.
