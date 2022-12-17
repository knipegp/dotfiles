# Ansible Collection - gknipe.personal

Documentation for the collection.

## Testing

Create a scenario by adding a new directory
`extentions/molecule/<scenario-name>`. Add the following files to that
directory:

1. Empty Yaml file `molecule.yml`
2. `converge.yml` playbook importing the role(s) under test

From the `extensions` directory, run `molecule -c molecule/molecule.yml
test -s <scenario-name>` to test a scenario.
