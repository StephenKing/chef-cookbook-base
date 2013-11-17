The intelligent base role
=========================

.. which is in fact a cookbook :-)

Due to the need of applying different roles/customizations to some groups of hosts,
based on different influence factors (like the data center where the node is running
or if it is a physical or a virtualized host).

After we were bored to manually update the role for the data center in which a VM
is running after a server move or the stupidity to declare a `debian` role during
node bootstrap, we decided to refactor our `base` cookbook and e.g. make use of
information coming from [Ohai](docs.opscode.com/ohai.html) through automatic
attributes (like `node[:platform] = "debian"`).

While such details like operating system specific things are not handled in this cookbook yet,
this is the starting point for all the magic and also home of couple of libraries, which are
explained below


Operating System Configuration
-------------------------------

This part automatically includes the `operatingsystem` cookbook.


Physical / Virtual Node Customizations
--------------------------------------

If the node is running on bare metal, the `base::physical` recipe is automatically included. If not (thus running virtualized), then `base::virtualized` allows customizations only for virtual machines.

Virtualization Techniques
-------------------------

If any virtualization technique is in use, the cookbook for this technique is automatically (gracefully) loaded (`node[:virtualization][:system]` is `vbox, openvz, vmware, ...`). If the a `#{node[:virtualization]][:system]}::default` recipe is not available, no error is thrown.

It is then the job of that cookbook to differ between custmomizations for host/guest.

Datacenter-specific Configuration
---------------------------------

In case we are not running on `chef-solo`, whe include our `datacenter` cookbook, which then on the one hand deploys essentials for running in production (like including monitoring) and on the other hand can apply DC-specific customizations (like NTP or mail-relay servers), based on the information, in what DC it is running.

Base Libraries
--------------

Typo3::Base::Recipe
*******************

In order to include specialized recipes only if they exist (but not to fail when
they not exist) we created the `include_if_available` functionality.

For example, we would not fail a chef run, if this `base` role (and the included
`operatingsystem` cookbook) would run on a CentOS node, when wo do not need any
customizations for that and thus have no dedicated recipe.

Instead of

```ruby
include_recipe "operatingsystem::#{node[:platform]}"
```

which would fail when somebody tries a new platform, the library enables us to savely do this

```ruby
include_if_available "operatingsystem::#{node[:platform]}"
```   

Typo3::Base::Node
*****************

This library gives information about the machine, where Chef is running.

* `physical?` - `true`, if the node is running on bare metal
* `virtualized?` - `true`, if Ohai detected that this node is running within a virtualized environment
* `virtualization?` - `true`, if virtualization is in use and this node is either _host_ or _guest_.