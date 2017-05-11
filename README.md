# GitHub + DITA based WIKI example (ghd-wiki)

This project shows a basic Wiki implementation based on GitHub as content repository, Travis for automatic builds, XSLT as scripting language and DITA as the source format.

<http://georgebina.github.io/ghd-wiki>

The content stays in the *master* branch in the `wiki` subfolder and you can place there DITA topics which will be automatically published by *travis* to HTML using the `publish/publish.xsl` XSLT script and commited on the *gh-pages* branch which is served by *GitHub Pages* as a website.

To get the same functionality under your account, you need to follow the steps below:

- Fork the project
- Under the *Settings* tab in GitHub make sure the *GitHub Pages* section says
  ```Your GitHub Pages site is currently being built from the gh-pages branch.```
- Go to [Travis website](http://travis-ci.org) and use the *Sign in with GitHub* action then authorize Travis to access your account - this is needed to enable automatic building of the Wiki output as HTML and comminting the result on the *gh-pages* branch
- Identify then the forked repository and activate it using the *Activate repository* action
- Under *More options*->*Settings*  
    - Enable *Build only if .travis.yml is present*
    - Disable *Build pull requests*
    - Define the GH_TOKEN variable under *Environment Variables* by setting its value to a GitHub Token that you can generate from GitHub in order to enable Travis to commit on your GitHub repository.
To obtain that value, you need to go to *GitHub* and under *Settings* there is a *Personal access tokens* section. Use the *Generate new token* button to generate a token and enable the options under the *repo* category. Copy the token value and use it to define the value of the *GH_TOKEN* variable
    - Define the WEBHELP_LICENSE variable under *Environment Variables* by setting its value to the oXygen Webhelp license key, eclosed in quotes - this will be used by the publishing process to build the webhelp output. You can obtain a trial license from 
[http://oxygenxml.com/xml_webhelp/register.html](http://oxygenxml.com/xml_webhelp/register.html)  

- You need to push some changes to GitHub on the *master* branch to force an initial build that will fix the links for the generated website to be for your project, rather than for the forked project. One possibility is to edit this file and push it to the repository, then you should find the updated website on GitHub Pages.

- Check on the Travis website and see when the build is finalised, then your project GitHub Pages will be up-to-date and you can use the generated website.

##Note
The GitHub Pages URL where you can see the Wiki is something like 
[http://georgebina.github.io/ghd-wiki](http://georgebina.github.io/ghd-wiki)
If you forked the project then the URL needs to be updated to contain your user name and your project name.

##Note
Creating a new file requires you to paste the initial content of a topic, which you can find below:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE topic PUBLIC "-//OASIS//DTD LW DITA Topic//EN" "topic.dtd">
<topic id="topic_ohd_twt_1x">
  <title>New topic</title>
  <body>
    <p>Content...</p>
  </body>
</topic>
```

