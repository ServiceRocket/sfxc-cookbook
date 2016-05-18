SFXC Cookbook
=============

This cookbook collects the scripts required to provision [SFXC][1] deployments. It is designed to fit any SFXC installation 
and should expose deployment specifics as attributes with reasonable default values.

Prerequisites
-------------

To package and deploy this project you should have the following programs installed:

* Berkshelf (or the Chef Development Kit, ChefDK, which includes Berkshelf)
* AWS CLI 

Install the Chef Development Kit from [https://downloads.chef.io/chef-dk/](https://downloads.chef.io/chef-dk/) or Mac 
users can install with `brew cask` using

    > brew cask install chefdk
    
To install the AWS CLI follow the instructions on the AWS website.

Release this cookbook
---------------------

1.  Bump the cookbook version in `metadata.rb` according to [semver](http://semver.org/) rules.

1.  Build a Berkshelf package using

        > berks package sfxc-cookbook-[version].tar.gz

    to create a deployable artifact. Replace `version` with the current cookbook version from `metadata.rb`.

1.  Copy the built cookbook to the dedicated AWS S3 bucket:

        > aws s3 cp sfxc-cookbook-[version].tar.gz s3://sfxc-cookbook/sfxc-cookbook-[version].tar.gz
        
1.  Verify you cookbook is successfully uploaded using

        > aws s3 ls s3://sfxc-cookbook
        
1.  Tag the current commit with the released version and push the tag to remote, e.g. `v0.2.0`
        
To apply a new version of this cookbook to a stack update the cookbook configuration in the stack settings and point
to the newly published version in the `sfxc-cookbook` bucket in AWS S3.


[1]: SFXC stands for: Salesforce X Connect where X can be JIRA, Confluence or HipChat.