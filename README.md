NTStation 13 - March 2014 [![Build Status](https://travis-ci.org/NTStation/NTstation13.png)](https://travis-ci.org/NTStation/NTstation13)

Website: http://tgstation13.org/

Code: https://github.com/NTStation/Ntstation13

Fourms:  http://tgstation13.org/phpBB/

# DOWNLOADING

There are a number of ways to download the source code. Some are described here, an alternative all-inclusive guide is also located at http://tgstation13.org/wiki/Downloading_the_source_code

Option 1: Download the source code as a zip by clicking the ZIP button in the
code tab of https://github.com/NTStation/Ntstation13
(Note: This will use a lot of bandwidth if you wish to update and is a lot of
hassle if you want to make any changes at all, so it's not recommended.)

(Options 2/3): Install Git-scm from here first: http://git-scm.com/download/win

Option 2:
Install GitHub::windows from http://windows.github.com/
It handles most of the setup and configuraton of Git for you.
Then you simply search for the NTStation13 repository and click the big clone
button.

Option 3:
Follow this: http://tgstation13.org/wiki/Setting_up_git
(It's recommended that you use git-scm, as above, rather than the git CLI
suggested by the guide)

#INSTALLATION

First-time installation should be fairly straightforward.  First, you'll need
BYOND installed. You can get it from http://www.byond.com/. Once you've done 
that, extract the game files to wherever you want to keep them.  This is a
sourcecode-only release, so the next step is to compile the server files.
Open NTstation.dme by double-clicking it, open the Build menu, and click
compile.  This'll take a little while, and if everything's done right you'll get
a message like this:

```
saving NTstation.dmb (DEBUG mode)
NTstation.dmb - 0 errors, 0 warnings
```

If you see any errors or warnings, something has gone wrong - possibly a corrupt
download or the files extracted wrong. If problems persist, ask for assistance
on the forums.

Once that's done, open up the config folder.  You'll want to edit config.txt to
set the probabilities for different gamemodes in Secret and to set your server
location so that all your players don't get disconnected at the end of each
round.  It's recommended you don't turn on the gamemodes with probability 0, 
except Extended, as they have various issues and aren't currently being tested,
so they may have unknown and bizarre bugs.  Extended is essentially no mode, and
isn't in the Secret rotation by default as it's just not very fun.

You'll also want to edit config/admins.txt to remove the default admins and add
your own.  "Game Master" is the highest level of access, and probably the one
you'll want to use for now.  You can set up your own ranks and find out more in
config/admin_ranks.txt

The format is:

```
byondkey = Rank
```

Where the admin rank must be properly capitalised.

Finally, to start the server, run Dream Daemon and enter the path to your
compiled NTstation.dmb file.  Make sure to set the port to the one you 
specified in the config.txt, and set the Security box to 'Safe'.  Then press GO
and the server should start up and be ready to join.

#UPDATING

To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

Then, extract the new files (preferably into a clean directory, but updating in
place should work fine), copy your /config and /data folders back into the new
install, overwriting when prompted except if we've specified otherwise, and
recompile the game.  Once you start the server up again, you should be running
the new version.

#SQL SETUP

The SQL backend for the library and stats tracking requires a 
MySQL server.  Your server details go in /config/dbconfig.txt, and the SQL 
schema is in /SQL/database_schema.sql.  More detailed setup instructions are located here: http://tgstation13.org/wiki/Downloading_the_source_code#Setting_up_the_database

#IRC BOT SETUP

Included in the SVN is an IRC bot capable of relaying adminhelps to a specified
IRC channel/server (thanks to Skibiliano).
Instructions for bot setup are included in the /bot folder along with the script
itself

#CONTRIBUTING
Everyone is free to contribute to this project as long as they follow these simple guidelines and specifications.

**Introduction**

NTStation13 is a fork from the /tg/station branch on March 6th, 2014.  It is devoted to having more freedom with commits, and trying to enjoy both coding and playing.

**Specification**

As BYOND's Dream Maker is an object oriented language, code must be object oriented when possible in order to be more flexible when adding content to it.

You must write BYOND code with absolute pathing, like so:

```C++

/obj/item/weapon/baseball_bat
    name = "baseball bat"
    desc = "A baseball bat."
    var/wooden = 1

/obj/item/weapon/baseball_bat/examine()
    if(wooden)
        desc = "A wooden baseball bat."
    else
        desc = "A metal baseball bat."
    ..()

```

You must not use colons to override safety checks on an object's variable/function, instead of using proper type casting.

It is rarely allowed to put type paths in a text format, as they is no compile errors if the type path no longer exists.

You must use tabs to indent your code.

Hacky code, such as adding specific checks, is highly discouraged and only allowed when there is no other option. You can avoid hacky code by using object oriented methodologies, such as overriding a function (called procs in DM) or sectioning code into functions and then overriding them as required.

Duplicated code is 99% of the time never allowed. Copying code from one place to another may be suitable for small short time projects but NTStation13 focuses on the long term and thus discourages this. Instead you can use object orientation, or simply placing repeated code in a function, to obey this specification easily.

Code should be modular where possible, if you are working on a new class then it is best if you put it in a new file.

Bloated code may be necessary to add a certain feature, which means there has to be a judgement over whether the feature is worth having or not. You can help make this decision easier by making sure your code is modular.

You are expected to help maintain the code that you add, meaning if there is a problem then you are likely to be approached in order to fix any issues, runtimes, or bugs.

**Getting Started**

We have a [list of guides on the wiki](http://tgstation13.org/wiki/Guides#Development_and_contribution_guides) which will help you get started contributing to NTStation13 with git and Dream Maker.

For beginners, it is recommended you work on small projects, at first. There is an easy list of issues which are [contributor friendly, here](https://github.com/NTStation/NTStation13/issues?labels=Contributor+Friendly&page=1&state=open).

#LICENSE

All code is under a GNU GPL v3 license (http://www.gnu.org/licenses/gpl.html),
including tools unless their readme specifies otherwise.
All content including icons and sound is under a Creative Commons 3.0 BY-SA
license (http://creativecommons.org/licenses/by-sa/3.0/).
