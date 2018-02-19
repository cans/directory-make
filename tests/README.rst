Running the tests
=================

If you want to run the tests locally, you will need to:


- Put yourself inside the root directory of this project, that is
  the parent directory of the on containing this file::

    $ cd path/to/ssh-configure

- create a new virtualenv for this project::

    $ module="$([ '2' = "`python --version 2>&1 | cut -f 2 -d \  | head -c 1`" ] && echo 'virtualenv' || echo 'venv'
    $ python -m "${module}" ansible-role-testing

  Or, if you use virtualenvwrappers::

    $ mkvirtualenv -a . -r tests/requirements.txt ansible-role-testing

- Install the Python requirements (*cf.* the requirements.txt file)
  from PyPI (not needed if you use ``mkvirtualenv`` as shown above)::

    $ pip install -r requirements.txt

- Setup docker on your system (*cf.* _[#])
- Install the roles required by the test-runner playbook (local.yml)::

    $ ansible-galaxy install -r tests/requirements.yml

  The roles will be installed under ``tests/roles``, as configure by the
  ``ansible.cfg`` file found in this role's root directory.
- Run the tests::

    $ ansible-playbook --connection=local -i tests/inventory tests/local.yml


The test suite itself is in the ``tests/test.yml`` playbook. The
``local.yml`` playbook is just here to bootstrap a docker container
in which the tests will be run. That way you don't risk messing with
your machine's configuration while testing this role. You'll just mess
the docker container instance.


A note on Debian systems
------------------------

Installing docker from the distribution packages does not always work.
You may need to deinstall those packages (``docker.io``, ``docker-runc``,
``docker-containerd``, ...) and install the one provided by docker:
``docker-ce`` _[1]

A note on Ansible module's Python requirements not found issues
---------------------------------------------------------------

A second issue comes from using Ansible from within a Python
virtualenv. You can easily face issues of Ansible tasks not finding the
Python modules it requires to perform, when working on the local host
(with or without the ``--connection=local`` option). A typical example
is the complaint that the ``docker`` is missing despite the module
being properly installed in the virtualenv.
When you come to think a bout it that's quite normal, if you understand
how Ansible works:

# it reads your playbooks, collecting variables, tasks to perform;
# for each tasks it generates a Python script that is fed with
  arguments that come from the variables evaluation;
# it uploads your script to the remote host;
# then runs it by issuing a ``/bin/sh -c '/path/to/uploaded/script.py'``;

For that command to work it is required that ``script.py`` contains a
shebang. By default it is ``#!/usr/bin/python``. Let's repeat those
operations in the specific case of running a task on the localhost,
with the ``--connection=local`` option:

# it reads your playbooks, collecting variables, tasks to perform
  Nothing changed here;
# for each tasks it generates a Python script that is fed with
  arguments that come from the variables evaluation. Again nothing
  new here;
# it *doesn't* upload the script (no need the script is already on the
  right machine, no need to waste time here;
# it run the generated ``script.py`` with the shebang
  ``#!/usr/bin/python``. Once more, not much changed here;

So what's different ? Well the difference is in that last step: in the
``"regular"`` remote execution of ``script.py`` you would have made
sure that the requirements were install properly before hand. But
locally, *if you use a virtualenv*, the dependencies you installed
*are not available* to the *globally installed* interpreter:
``/usr/bin/python``. Only its copy **within the virtualenv** can find
then. That is would like the shebang to be something like
``#!~/.virtualenv/ansible-role-testing/bin/python`` (assuming you
followed the instructions above, to create the virtualenv), with the
``~`` expanded of course.

Well it turns out that you can ask Ansible to do exactly that. All is
required is for you to define the ``ansible_python_interpreter``
variable on in the target host facts (here ``localhost``). I generally
find the most convenient what to do that to be adding that variable at
the inventory level:

.. code-block:: INI

     localhost ansible_python_interpreter='/usr/bin/env python'

An alternative work around is to install it, using either your
distribution's packages or pip, either at the system level or on your
personal account if the later is not an option::

    install at the system level
    # apt-get install python-docker

    install on your personal account
    $ pip install --user docker>=2.4.0,<3.0

That latter option may not work if your playbook needs to change user !

.. [#] See https://docs.docker.com/install/linux/docker-ce/debian/#install-docker-ce-1
