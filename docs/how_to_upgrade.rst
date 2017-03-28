
This section shows you how to upgrade to an old verion to the newer version of teracy-dev.

From teracy-dev v0.4.2 to v0.5.0
===============================

1. Check the VBox and vagrant version:
    ::

        $ VBoxManage --version
        $ vagrant --version

- If VBox version is >=5.1,  vagrant verson is >=1.8, it's good, you don't need to uninstall them. Otherwise, you need to uninstall and install them again.


2. Uninstall the old Vbox and vagrant version:
	::
		$ brew cask uninstall virtualbox
		$ brew cask uninstall vagrant


3. Install Vbox and vagrant v1.8.7 
Depending on your OS, follow the instruction at http://dev.teracy.org/docs/develop/getting_started.html#manual-installation-on-macos

4. Go to the teracy-dev folder and destroy the old vagrant version
	::

		$ cd ~/teracy-dev
		$ vagrant destroy

5. Rename the folder *teracy* into *teracy-dev-old* and keep it that.
		$ cd ~
		$ mv teracy-dev teracy-dev-old

6. Clone the new one and vagrant up by following the instruction at http://dev.teracy.org/docs/develop/getting_started.html#teracy-dev-git-clone-and-vagrant-up

You are recommended to clone the new one, because there are many big changes which are not compatiple with the old version. 

That's done! Now you should work with the teracy-dev v0.5.0.