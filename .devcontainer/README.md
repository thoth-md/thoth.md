# Dev Container Local Setup

> Note: If you are coding from a mobile device in GitHub, just use the "Code" drop down and switch to the Codespace tab to create this as a cloud hosted VSCode instance.

To create a custom dev workspace with isolated file system on your workstation (must have docker installed and running):
* Open the VS Code command pallete (from any project)
* Search *EXACTLY* for: "Dev Containers: Clone repository in named container volume..." (make sure it says "named volume")
* Select this repository
* Name the volume after this repository or in a way you will recognize
* Accept the default name for the folder (it's the repo name)
* Wait for new container to load...
Bonus (if you work on multiple instances of this project or multiple projects simultaneously, color code using VSCose workspaces)
* Go to File, select "Open workspace from file"
* select the corresponding color workspace
* At this momemnt: Pin the latest recent item in the VS Code taskbar menu so you don't have to guess how to open this exact scenario again.

## Once in
* Run Claude to get logged in and configured
