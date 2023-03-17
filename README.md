# Locally connect VSCode to a Coder container

## Install

Install the [coder CLI](https://coder.com/docs/v1/latest/cli/installation) From your local machine. To do so navigate to the [coder/v1/release](https://github.com/coder/coder-v1-cli/releases) and download the coder-cli-windows.zip

Once the zip is downloaded, extract and place the executable in your windows `PATH`.

To get a list of your available `PATH` options.

```powershell
PS C:\windows\system32> cd env:
PS Env:\> (gci path).value
```

Once you have put the executable in your `PATH` check that this is configured correctly.

```powershell
PS C:\windows\system32> coder --version
```

## Login

Now with the coder cli enabled on your local machine you need to login.  The command below will open a browser instance to authenticate.

``` powershell
PS C:\windows\system32> coder login https://coder.tools.afweather.mil/
```

Ensure you have a running workspace to ssh into.  If you do not go to the [coder workspaces](https://coder.tools.afweather.mil/workspaces) and run one.  Run the command below to see what workspaces you have available.

```powershell
PS C:\windows\system32> coder workspaces ls
```

```text
warning: version mismatch detected
  | Coder CLI version: v1.40.0
  | Coder API version: 1.32.0
  |
  | tip: download the appropriate version here: https://github.com/coder/coder-cli/releases
  | tip: alternatively, run `coder update`
Name        Image                                 vCPU    MemoryGB    DiskGB    Status    Provider    CVM      Username
base-ubi    codercom/enterprise-base:ubuntu       8       16          10        ON        us-west     false    leaver
kinetic     ubuntu:kinetic                        4       4           10        FAILED    us-west     false    leaver
pycharm     codercom/enterprise-pycharm:ubuntu    4       8           10        OFF       us-west     false    leaver
```

## Configure

In the local machine you now need to configure the ssh connection

``` powershell
PS Env:\> coder config-ssh
>>
```
## Done

You should be able to SSH into coder from the local machine.

```bash
PS Env:\> ssh coder.base-ubi
(base) coder@base-ubi:~$ python -V
Python 3.9.12
```
