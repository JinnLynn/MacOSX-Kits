# Shell

一些个人使用Shell Scripts。

`build-env.sh`是建立环境的脚本，需配置环境变量`KITS`，同时也要让它在bash启动脚本中执行，即在~/.bash_profile中添加`source PATH/TO/build-env.sh`。

`kits`是所有脚本的统一入口命令，用法如`kits usage`、`kits backup`、`kits mamp start`。