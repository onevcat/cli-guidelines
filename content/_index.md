# 命令行界面设计指南 {#command-line-interface-guidelines}

这是 [Command Line Interface Guidelines](https://clig.dev/) 的中文翻译，基于 [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) 协议[开源](https://github.com/onevcat/cli-guidelines)。本指南旨在帮助你编写更好的命令行程序，以传统 UNIX 原则为基础，并针对现代需求进行了更新。

## 作者 {#authors}

**Aanand Prasad** \
Squarespace 工程师，Docker Compose 联合创建者。\
[@aanandprasad](https://twitter.com/aanandprasad)

**Ben Firshman** \
[Replicate](https://replicate.ai/) 联合创建者，Docker Compose 联合创建者。\
[@bfirsh](https://twitter.com/bfirsh)

**Carl Tashian** \
[Smallstep](https://smallstep.com/) Offroad 工程师，Zipcar 首位工程师，Trove 联合创始人。\
[tashian.com](https://tashian.com/) [@tashian](https://twitter.com/tashian)

**Eva Parish** \
Squarespace 技术文档工程师，O'Reilly 撰稿人。\
[evaparish.com](https://evaparish.com/) [@evpari](https://twitter.com/evpari)

设计：[Mark Hurrell](https://mhurrell.co.uk/)。感谢 Andreas Jansson 的早期贡献，以及 Andrew Reitz、Ashley Williams、Brendan Falk、Chester Ramey、Dj Walker-Morgan、Jacob Maine、James Coglan、Michael Dwan 和 Steve Klabnik 审阅草稿。

中文翻译：[Wei Wang (onevcat)](https://onevcat.com) 和他的一众 AI 助手。

<iframe class="github-button" src="https://ghbtns.com/github-btn.html?user=cli-guidelines&repo=cli-guidelines&type=star&count=true&size=large" frameborder="0" scrolling="0" width="170" height="30" title="GitHub"></iframe>

如果你想讨论本指南或 CLI 设计，欢迎[加入我们的 Discord](https://discord.gg/EbAW5rUCkE)。


## 前言 {#foreword}

在 1980 年代，如果你想让个人电脑为你做些什么，你需要知道在面对 `C:\>` 或 `~$` 时该输入什么。
帮助来自厚重的螺旋装订手册。
错误信息晦涩难懂。
那时还没有 Stack Overflow 可以拯救你。
但如果你有幸能上网，你可以从 Usenet 获得帮助——一个早期的互联网社区，里面都是和你一样沮丧的人。
他们要么帮你解决问题，要么至少提供一些精神支持和同病相怜的慰藉。

四十年后，计算机变得更加普及，但这往往是以牺牲底层终端用户控制权为代价的。
在许多设备上，根本没有命令行访问权限，部分原因是这与围墙花园和应用商店的商业利益相悖。

今天大多数人不知道命令行是什么，更不知道为什么要费心使用它。
正如计算机先驱 Alan Kay 在 [2017 年的一次采访](https://www.fastcompany.com/40435064/what-alan-kay-thinks-about-the-iphone-and-technology-now)中所说："因为人们不理解计算是什么，他们以为 iPhone 就是计算的全部，这种错觉就像以为玩《劲舞团》，就等于会跳真正的街舞一样。"

Kay 所说的"真正的街舞"并不完全是指 CLI。
他谈的是编程计算机的方式，这些方式提供了 CLI 的能力，并超越了在文本文件中编写软件的范畴。
Kay 的追随者们相信，我们需要突破几十年来一直生活其中的基于文本的局部最优。

想象一下，我们会以完全不同方式进行计算机编程，这样的未来令人兴奋。
即使在今天，电子表格依然是迄今为止最流行的编程语言，而无代码运动也在快速兴起，试图取代对优秀程序员的部分强烈需求。

然而，尽管命令行有着几十年的陈旧约束和莫名其妙的怪癖，它仍然是计算机中最*通用*的角落。
它让你能够揭开帷幕，看到真正发生的事情，并以 GUI 无法提供的复杂度和深度与机器进行创造性的交互。
它几乎在任何笔记本电脑上都可用，任何想学习的人都能使用。
它可以交互式使用，也可以自动化。
而且，它不像系统的其他部分那样变化迅速。
它的稳定性具有创造性价值。

所以，既然我们还拥有它，我们就应该努力最大化它的实用性和可访问性。

自那些早期以来，我们编程计算机的方式发生了很大变化。
过去的命令行是*机器优先*的：不过是脚本平台之上的一个 REPL。
但随着通用解释型语言的蓬勃发展，shell 脚本的角色已经缩小。
今天的命令行是*人类优先*的：一个基于文本的用户界面，提供对各种工具、系统和平台的访问。
过去，编辑器在终端内部——今天，终端同样经常是编辑器的一个功能。
而且出现了大量类似 `git` 的多功能命令。
命令中嵌套命令，以及执行完整工作流而非原子功能的高级命令。

受传统 UNIX 哲学的启发，出于对鼓励更令人愉悦和更易访问的 CLI 环境的兴趣，并以我们作为程序员的经验为指导，我们决定是时候重新审视构建命令行程序的最佳实践和设计原则了。

命令行万岁！

## 简介 {#introduction}

本文档涵盖高层设计哲学和具体指南两方面。
指南部分篇幅更多，因为作为实践者，我们的哲学就是不要过度哲学化。
我们相信通过示例学习，所以提供了大量例子。

本指南不涉及像 emacs 和 vim 这样的全屏终端程序。
全屏程序是小众项目——我们中很少有人会处于需要设计此类程序的位置。

本指南对编程语言和工具保持中立。

本指南适合谁？
- 如果你正在创建一个 CLI 程序，并且正在寻找其 UI 设计的原则和具体最佳实践，本指南适合你。
- 如果你是一名专业的"CLI UI 设计师"，那太棒了——我们很想向你学习。
- 如果你想避免那些违背 40 年 CLI 设计惯例的明显失误，本指南适合你。
- 如果你想用程序的良好设计和有帮助的帮助信息来取悦用户，本指南绝对适合你。
- 如果你正在创建 GUI 程序，本指南不适合你——尽管如果你决定阅读它，你可能会学到一些 GUI 反模式。
- 如果你正在设计一个沉浸式的、全屏的 CLI 版 Minecraft，本指南不适合你。
  （但我们迫不及待想看到它！）

## 设计哲学 {#philosophy}

以下是我们认为良好 CLI 设计的基本原则。

### 人类优先设计 {#human-first-design}

传统上，UNIX 命令是在假设它们主要被其他程序使用的前提下编写的。
它们与编程语言中的函数比与图形应用程序有更多共同点。

今天，即使许多 CLI 程序主要（甚至完全）由人类使用，它们的交互设计仍然承载着过去的包袱。
是时候甩掉这些包袱了：如果一个命令主要由人类使用，它就应该首先为人类设计。

### 简单的部件协同工作 {#simple-parts-that-work-together}

[原始 UNIX 哲学](https://en.wikipedia.org/wiki/Unix_philosophy)的核心原则是：具有清晰接口的小型、简单程序可以组合起来构建更大的系统。
与其在这些程序中塞入越来越多的功能，不如让程序足够模块化，以便根据需要重新组合。

在过去，管道和 shell 脚本在程序组合过程中扮演着关键角色。
它们的角色可能随着通用解释型语言的兴起而减弱，但它们肯定没有消失。
更重要的是，大规模自动化——以 CI/CD、编排和配置管理的形式——已经蓬勃发展。
使程序可组合与以往一样重要。

幸运的是，UNIX 环境中长期建立的惯例，正是为此目的而设计的，今天仍然帮助着我们。
标准输入/输出/错误、信号、退出码和其他机制确保不同程序能够很好地协作。
纯文本、基于行的文本很容易在命令之间管道传输。
JSON，一个更近期的发明，在我们需要时提供了更多结构，让我们更容易将命令行工具与 Web 集成。

无论你构建什么软件，你都可以绝对确定人们会以你没有预料到的方式使用它。
你的软件*将*成为更大系统的一部分——你唯一的选择是它是否会成为一个行为良好的部件。

最重要的是，为可组合性设计不需要与人类优先设计相矛盾。
本文档中的许多建议都是关于如何同时实现这两者的。

### 跨程序的一致性 {#consistency-across-programs}

终端的惯例已经刻入我们的手指。
我们必须通过学习命令行语法、标志、环境变量等来支付前期成本，但这在长期效率上得到了回报……只要程序是一致的。

在可能的情况下，CLI 应该遵循已经存在的模式。
这就是让 CLI 直观和可猜测的原因；这就是让用户高效的原因。

话虽如此，有时一致性与易用性冲突。
例如，许多长期存在的 UNIX 命令默认不输出太多信息，这可能会让不太熟悉命令行的人感到困惑或担忧。

当遵循惯例会损害程序的可用性时，可能是时候打破它了——但这样的决定应该谨慎做出。

### 说得恰到好处 {#saying-just-enough}

终端是一个纯信息的世界。
你可以说信息就是界面——而且，就像任何界面一样，信息往往太多或太少。

当一个命令挂起几分钟而用户开始怀疑它是否坏了时，命令就是说得太少了。
当一个命令倾倒出页面又页面的调试输出，将真正重要的东西淹没在一片松散的碎屑海洋中时，命令就是说得太多了。
最终结果是一样的：缺乏清晰度，让用户困惑和恼火。

要达到这种平衡可能非常困难，但如果软件要赋能并服务其用户，这绝对是至关重要的。

### 易于发现 {#ease-of-discovery}

在让功能可发现方面，GUI 占据优势。
你能做的一切都摆在屏幕前，所以你不需要学习任何东西就能找到你需要的，甚至可能发现你不知道可以做的事情。

人们假设命令行界面与此相反——你必须记住如何做一切事情。
1987 年发布的原版 [Macintosh Human Interface Guidelines](https://archive.org/details/applehumaninterf00appl) 推荐"看和指（而不是记住和输入）"，好像你只能选择其中之一。

这些事情不必相互排斥。
使用命令行的效率来自于记住命令，但没有理由命令不能帮助你学习和记忆。

可发现的 CLI 有完整的帮助文本，提供大量示例，建议接下来运行什么命令，建议出错时该怎么做。
有很多想法可以从 GUI 中借鉴，使 CLI 更容易学习和使用，即使对于高级用户也是如此。

*引用：The Design of Everyday Things (Don Norman)，Macintosh Human Interface Guidelines*

### 对话是常态 {#conversation-as-the-norm}

GUI 设计，尤其在早期，大量使用*隐喻*：桌面、文件、文件夹、回收站。
这很有意义，因为计算机仍在试图引导自己进入合法性。
隐喻的实现便利性是 GUI 相对于 CLI 的巨大优势之一。
然而，讽刺的是，CLI 一直体现着一个意外的隐喻：它是一场对话。

除了最简单的命令，运行一个程序通常涉及不止一次调用。
通常，这是因为很难第一次就做对：用户输入一个命令，得到一个错误，修改命令，得到一个不同的错误，如此反复，直到成功。
这种通过反复失败学习的模式就像用户与程序之间的对话。

然而，试错并不是唯一的对话式交互类型。
还有其他类型：

- 运行一个命令来设置工具，然后学习运行哪些命令来实际开始使用它。
- 运行多个命令来设置一个操作，然后运行最后一个命令来执行它（例如，多个 `git add`，然后是 `git commit`）。
- 探索一个系统——例如，做大量的 `cd` 和 `ls` 来了解目录结构，或者用 `git log` 和 `git show` 来探索文件的历史。
- 在实际运行之前对复杂操作进行预演。

承认命令行交互的对话性质意味着你可以将相关技术应用于其设计。
当用户输入无效时，你可以建议可能的更正，当用户正在进行多步骤过程时，你可以让中间状态清晰可见，在他们做一些可怕的事情之前，你可以为他们确认一切看起来都很好。

无论你是否有意为之，用户都在与你的软件对话。
在最坏的情况下，这是一场敌对的对话，让他们感到愚蠢和怨恨。
在最好的情况下，这是一次愉快的交流，让他们带着新获得的知识和成就感快速前进。

*延伸阅读：[The Anti-Mac User Interface (Don Gentner and Jakob Nielsen)](https://www.nngroup.com/articles/anti-mac-interface/)*

### 健壮性 {#robustness-principle}

健壮性既是客观属性也是主观属性。
软件当然应该*是*健壮的：意外输入应该被优雅地处理，操作应该尽可能是幂等的，等等。
但它也应该*感觉*健壮。

你希望你的软件感觉不会散架。
你希望它感觉即时和响应，就好像它是一台大型机械机器，而不是一个脆弱的塑料"软开关"。

主观的健壮性需要关注细节，并认真思考什么可能出错。
它是很多小事情的集合：让用户了解正在发生什么，解释常见错误的含义，不打印看起来可怕的堆栈跟踪。

作为一般规则，健壮性也可以来自保持简单。
大量的特殊情况和复杂代码往往使程序变得脆弱。

### 同理心 {#empathy}

命令行工具是程序员的创意工具包，所以它们应该用起来很愉快。
这并不意味着把它们变成视频游戏，或使用大量 emoji（尽管 emoji 本身没有什么问题 😉）。
它意味着给用户一种感觉：你站在他们这边，你希望他们成功，你已经仔细考虑过他们的问题以及如何解决它们。

没有一份可以保证他们有这种感觉的行动清单，尽管我们希望遵循我们的建议会让你走完一部分路程。
取悦用户意味着在每一个转折点都*超越他们的期望*，而这始于同理心。

### 混沌 {#chaos}

终端的世界是一团混乱。
不一致性无处不在，减慢我们的速度，让我们质疑自己。

然而不可否认的是，这种混沌一直是力量的源泉。
终端，像一般的 UNIX 派生计算环境一样，对你能构建什么施加的约束很少。
在这个空间里，各种各样的发明蓬勃发展。

讽刺的是，本文档恳请你遵循现有模式，同时又给出了与数十年命令行传统相矛盾的建议。
我们和任何人一样，都在打破规则。

你也可能有一天不得不打破规则。
要有意图和目的清晰地这样做。

> "当一个标准明显损害生产力或用户满意度时，就放弃它。" — Jef Raskin，[The Humane Interface](https://en.wikipedia.org/wiki/The_Humane_Interface)

## 指南 {#guidelines}

这是一组可以让你的命令行程序变得更好的具体事项。

第一部分包含你需要遵循的基本事项。
如果这些做错了，你的程序要么难以使用，要么是一个糟糕的 CLI 公民。

其余的是锦上添花。
如果你有时间和精力添加这些东西，你的程序将比一般程序好得多。

理念是，如果你不想对程序的设计思考太多，你不必：只需遵循这些规则，你的程序可能会很好。
另一方面，如果你已经思考过并确定某条规则对你的程序不适用，那也没问题。
（没有什么中央机构会因为你没有遵循任意规则而拒绝你的程序。）

另外——这些规则并非一成不变。
如果你有充分理由不同意某条一般规则，我们希望你能[提出修改](https://github.com/cli-guidelines/cli-guidelines)。

### 基础 {#the-basics}

有一些基本规则你需要遵循。
如果这些做错了，你的程序要么非常难以使用，要么完全损坏。

**尽可能使用命令行参数解析库。**
使用你的语言内置的，或一个好的第三方库。
它们通常会以合理的方式处理参数、标志解析、帮助文本，甚至拼写建议。

以下是一些我们喜欢的：
* 多平台：[docopt](http://docopt.org)
* Bash：[argbash](https://argbash.dev)
* Go：[Cobra](https://github.com/spf13/cobra)、[cli](https://github.com/urfave/cli)
* Haskell：[optparse-applicative](https://hackage.haskell.org/package/optparse-applicative)
* Java：[picocli](https://picocli.info/)
* Julia：[ArgParse.jl](https://github.com/carlobaldassi/ArgParse.jl)、[Comonicon.jl](https://github.com/comonicon/Comonicon.jl)
* Kotlin：[clikt](https://ajalt.github.io/clikt/)
* Node：[oclif](https://oclif.io/)
* Deno：[parseArgs](https://jsr.io/@std/cli/doc/parse-args/~/parseArgs)
* Perl：[Getopt::Long](https://metacpan.org/pod/Getopt::Long)
* PHP：[console](https://github.com/symfony/console)、[CLImate](https://climate.thephpleague.com)
* Python：[Argparse](https://docs.python.org/3/library/argparse.html)、[Click](https://click.palletsprojects.com/)、[Typer](https://github.com/tiangolo/typer)
* Ruby：[TTY](https://ttytoolkit.org/)
* Rust：[clap](https://docs.rs/clap)
* Swift：[swift-argument-parser](https://github.com/apple/swift-argument-parser)

**成功时返回零退出码，失败时返回非零。**
退出码是脚本判断程序成功还是失败的方式，所以你应该正确报告这一点。
将非零退出码映射到最重要的失败模式。

**将输出发送到 `stdout`。**
命令的主要输出应该发送到 `stdout`。
任何机器可读的内容也应该发送到 `stdout`——这是管道默认发送内容的地方。

**将消息发送到 `stderr`。**
日志消息、错误等都应该发送到 `stderr`。
这意味着当命令被管道连接在一起时，这些消息会显示给用户，而不是被输入到下一个命令。

### 帮助 {#help}

**被请求时显示详尽的帮助文本。**
当传入 `-h` 或 `--help` 标志时显示帮助。
这也适用于可能有自己帮助文本的子命令。

**默认显示简洁的帮助文本。**
当 `myapp` 或 `myapp subcommand` 需要参数才能运行，但运行时没有参数，显示简洁的帮助文本。

如果你的程序默认是交互式的（例如 `npm init`），你可以忽略这条指南。

简洁的帮助文本应该只包括：

- 程序做什么的描述。
- 一两个调用示例。
- 标志的描述，除非标志很多。
- 传递 `--help` 标志以获取更多信息的说明。

`jq` 做得很好。
当你输入 `jq` 时，它显示介绍性描述和示例，然后提示你传递 `jq --help` 以获取完整的标志列表：

```
$ jq
jq - commandline JSON processor [version 1.6]

Usage:    jq [options] <jq filter> [file...]
    jq [options] --args <jq filter> [strings...]
    jq [options] --jsonargs <jq filter> [JSON_TEXTS...]

jq is a tool for processing JSON inputs, applying the given filter to
its JSON text inputs and producing the filter's results as JSON on
standard output.

The simplest filter is ., which copies jq's input to its output
unmodified (except for formatting, but note that IEEE754 is used
for number representation internally, with all that that implies).

For more advanced filters see the jq(1) manpage ("man jq")
and/or https://stedolan.github.io/jq

Example:

    $ echo '{"foo": 0}' | jq .
    {
        "foo": 0
    }

For a listing of options, use jq --help.
```

**当传入 `-h` 和 `--help` 时显示完整帮助。**
以下所有都应该显示帮助：

```
$ myapp
$ myapp --help
$ myapp -h
```

忽略传入的任何其他标志和参数——你应该能够在任何命令末尾添加 `-h`，它就会显示帮助。
不要重载 `-h`。

如果你的程序是类似 `git` 的，以下也应该提供帮助：

```
$ myapp help
$ myapp help subcommand
$ myapp subcommand --help
$ myapp subcommand -h
```

**为反馈和问题提供支持路径。**
在顶级帮助文本中放一个网站或 GitHub 链接是常见做法。

**在帮助文本中链接到文档的网页版本。**
如果你对某个子命令有特定的页面或锚点，直接链接到那里。
这在网页上有更详细的文档，或者有可能解释某些行为的延伸阅读时特别有用。

**以示例开头。**
用户倾向于使用示例而不是其他形式的文档，所以在帮助页面中首先展示它们，特别是常见的复杂用法。
如果它有助于解释正在做什么并且不太长，也展示实际输出。

你可以用一系列示例讲述一个故事，逐步构建到复杂的用法。
<!-- TK example? -->

**如果你有大量示例，把它们放在别处，**比如一个速查表命令或网页。
有详尽的、高级的示例是有用的，但你不想让帮助文本太长。

对于更复杂的用例，例如与另一个工具集成，编写一个完整的教程可能是合适的。

**在帮助文本开头显示最常用的标志和命令。**
有很多标志是可以的，但如果你有一些真正常用的，首先显示它们。
例如，Git 命令首先显示入门命令和最常用的子命令：

```
$ git
usage: git [--version] [--help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           <command> [<args>]

These are common Git commands used in various situations:

start a working area (see also: git help tutorial)
   clone      Clone a repository into a new directory
   init       Create an empty Git repository or reinitialize an existing one

work on the current change (see also: git help everyday)
   add        Add file contents to the index
   mv         Move or rename a file, a directory, or a symlink
   reset      Reset current HEAD to the specified state
   rm         Remove files from the working tree and from the index

examine the history and state (see also: git help revisions)
   bisect     Use binary search to find the commit that introduced a bug
   grep       Print lines matching a pattern
   log        Show commit logs
   show       Show various types of objects
   status     Show the working tree status
…
```

**在帮助文本中使用格式化。**
粗体标题使扫描变得更容易。
但是，尽量以终端无关的方式做到这一点，这样你的用户就不会盯着一堵转义字符的墙。

<pre>
<code>
<strong>$ heroku apps --help</strong>
list your apps

<strong>USAGE</strong>
  $ heroku apps

<strong>OPTIONS</strong>
  -A, --all          include apps in all teams
  -p, --personal     list apps in personal account when a default team is set
  -s, --space=space  filter by space
  -t, --team=team    team to use
  --json             output in json format

<strong>EXAMPLES</strong>
  $ heroku apps
  === My Apps
  example
  example2

  === Collaborated Apps
  theirapp   other@owner.name

<strong>COMMANDS</strong>
  apps:create     creates a new app
  apps:destroy    permanently destroy an app
  apps:errors     view app errors
  apps:favorites  list favorited apps
  apps:info       show detailed app information
  apps:join       add yourself to a team app
  apps:leave      remove yourself from a team app
  apps:lock       prevent team members from joining an app
  apps:open       open the app in a web browser
  apps:rename     rename an app
  apps:stacks     show the list of available stacks
  apps:transfer   transfer applications to another user or team
  apps:unlock     unlock an app so any team member can join
</code>
</pre>

注意：当 `heroku apps --help` 通过分页器管道传输时，命令不输出转义字符。

**如果用户做错了什么，并且你可以猜到他们的意思，就建议它。**
例如，`brew update jq` 会告诉你应该运行 `brew upgrade jq`。

你可以询问他们是否想运行建议的命令，但不要强迫他们。
例如：

```
$ heroku pss
 ›   Warning: pss is not a heroku command.
Did you mean ps? [y/n]:
```

与其建议正确的语法，你可能会想直接为他们运行，就好像他们一开始就输入正确一样。
有时这是正确的做法，但不总是。

首先，无效输入不一定意味着简单的打字错误——它通常可能意味着用户犯了逻辑错误，或误用了 shell 变量。
假设他们的意思可能是危险的，特别是如果结果操作会修改状态。

其次，要意识到如果你改变了用户输入的内容，他们就不会学到正确的语法。
实际上，你是在裁定他们输入的方式是有效和正确的，你在承诺无限期地支持它。
在做出这个决定时要有意图，并记录两种语法。

*延伸阅读：["Do What I Mean"](http://www.catb.org/~esr/jargon/html/D/DWIM.html)*

**如果你的命令期望有东西管道输入，而 `stdin` 是交互式终端，立即显示帮助并退出。**
这意味着它不会像 `cat` 那样只是挂起。
或者，你可以向 `stderr` 打印一条日志消息。

### 文档 {#documentation}

[帮助文本](#help)的目的是给出你的工具是什么、有哪些选项可用以及如何执行最常见任务的简短、即时的概念。
另一方面，文档是你详细说明的地方。
这是人们去了解你的工具是做什么的、*不是*做什么的、它是如何工作的，以及如何做他们可能需要做的一切的地方。

**提供基于网页的文档。**
人们需要能够在线搜索你的工具的文档，并能够将其他人链接到特定部分。
网页是最具包容性的文档格式。

**提供基于终端的文档。**
终端中的文档有几个很好的特性：访问速度快，与工具的特定安装版本保持同步，并且在没有互联网连接的情况下也能工作。

**考虑提供 man 页面。**
[man 页面](https://en.wikipedia.org/wiki/Man_page)，Unix 的原始文档系统，今天仍在使用，许多用户在试图了解你的工具时会本能地首先检查 `man mycmd`。
为了更容易生成它们，你可以使用像 [ronn](http://rtomayko.github.io/ronn/ronn.1.html) 这样的工具（它也可以生成你的网页文档）。

然而，不是每个人都知道 `man`，而且它不能在所有平台上运行，所以你还应该确保你的终端文档可以通过工具本身访问。
例如，`git` 和 `npm` 通过 `help` 子命令使其 man 页面可访问，所以 `npm help ls` 等同于 `man npm-ls`。

```
NPM-LS(1)                                                            NPM-LS(1)

NAME
       npm-ls - List installed packages

SYNOPSIS
         npm ls [[<@scope>/]<pkg> ...]

         aliases: list, la, ll

DESCRIPTION
       This command will print to stdout all the versions of packages that are
       installed, as well as their dependencies, in a tree-structure.

       ...
```

### 输出 {#output}

**人类可读的输出是最重要的。**
人类优先，机器其次。
判断特定输出流（`stdout` 或 `stderr`）是否被人类阅读的最简单、最直接的启发式方法是*它是否是 TTY*。
无论你使用什么语言，它都会有一个用于此目的的实用程序或库（例如 [Python](https://stackoverflow.com/questions/858623/how-to-recognize-whether-a-script-is-running-on-a-tty)、[Node](https://nodejs.org/api/process.html#process*a*note*on*process*i*o)、[Go](https://github.com/mattn/go-isatty)）。

*关于[什么是 TTY](https://unix.stackexchange.com/a/4132) 的延伸阅读。*

**在不影响可用性的情况下提供机器可读的输出。**
文本流是 UNIX 中的通用接口。
程序通常输出文本行，程序通常期望文本行作为输入，因此你可以将多个程序组合在一起。这通常是为了使编写脚本成为可能，但它也可以帮助人类使用程序的可用性。
例如，用户应该能够将输出管道到 `grep`，它应该按照他们期望的方式工作。

> "期望每个程序的输出都能成为另一个尚未知的程序的输入。"
— [Doug McIlroy](http://web.archive.org/web/20220609080931/https://homepage.cs.uri.edu/~thenry/resources/unix_art/ch01s06.html)

**如果人类可读的输出破坏了机器可读的输出，使用 `--plain` 以纯表格文本格式显示输出，以便与 `grep` 或 `awk` 等工具集成。**
在某些情况下，你可能需要以不同的方式输出信息以使其对人类可读。
<!-- (TK example with and without --plain) -->
例如，如果你正在显示一个基于行的表格，你可能会选择将一个单元格拆分成多行，在保持在屏幕宽度内的同时容纳更多信息。
这打破了每行一条数据的预期行为，所以你应该为脚本提供一个 `--plain` 标志，它禁用所有此类操作并每行输出一条记录。

**如果传入了 `--json`，将输出显示为格式化的 JSON。**
JSON 允许比纯文本更多的结构，所以它使输出和处理复杂数据结构变得更加容易。
[`jq`](https://stedolan.github.io/jq/) 是在命令行上处理 JSON 的常用工具，现在有一个[完整的工具生态系统](https://ilya-sher.org/2018/04/10/list-of-json-tools-for-command-line/)输出和操作 JSON。

它也在网页上广泛使用，所以通过使用 JSON 作为程序的输入和输出，你可以使用 `curl` 直接管道到和从 Web 服务。

**成功时显示输出，但保持简短。**
传统上，当一切正常时，UNIX 命令不向用户显示任何输出。
这在它们被脚本使用时是有意义的，但在被人类使用时可能会使命令看起来像是挂起或损坏了。
例如，`cp` 不会打印任何东西，即使它需要很长时间。

什么都不打印很少是最佳的默认行为，但通常最好是少打印一些。

对于你确实希望没有输出的情况（例如，在 shell 脚本中使用时），为了避免笨拙地将 `stderr` 重定向到 `/dev/null`，你可以提供一个 `-q` 选项来抑制所有非必要的输出。

**如果你改变了状态，告诉用户。**
当命令改变系统的状态时，解释刚刚发生了什么特别有价值，这样用户可以在脑海中建立系统的状态模型——特别是当结果与用户请求的不直接对应时。

例如，`git push` 准确地告诉你它在做什么，以及远程分支的新状态：

```
$ git push
Enumerating objects: 18, done.
Counting objects: 100% (18/18), done.
Delta compression using up to 8 threads
Compressing objects: 100% (10/10), done.
Writing objects: 100% (10/10), 2.09 KiB | 2.09 MiB/s, done.
Total 10 (delta 8), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (8/8), completed with 8 local objects.
To github.com:replicate/replicate.git
 + 6c22c90...a2a5217 bfirsh/fix-delete -> bfirsh/fix-delete
```

**使查看系统当前状态变得容易。**
如果你的程序进行大量复杂的状态变化，并且这些变化在文件系统中不是立即可见的，确保你使这容易查看。

例如，`git status` 尽可能多地告诉你关于 Git 仓库当前状态的信息，以及一些如何修改状态的提示：

```
$ git status
On branch bfirsh/fix-delete
Your branch is up to date with 'origin/bfirsh/fix-delete'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   cli/pkg/cli/rm.go

no changes added to commit (use "git add" and/or "git commit -a")
```

**建议用户应该运行的命令。**
当多个命令形成一个工作流时，向用户建议他们接下来可以运行的命令可以帮助他们学习如何使用你的程序并发现新功能。
例如，在上面的 `git status` 输出中，它建议了你可以运行来修改你正在查看的状态的命令。

**跨越程序内部世界边界的操作通常应该是显式的。**
这包括：

- 读取或写入用户没有显式传递为参数的文件（除非这些文件存储内部程序状态，如缓存）。
- 与远程服务器通信，例如下载文件。

**增加信息密度——用 ASCII 艺术！**
例如，`ls` 以可扫描的方式显示权限。
当你第一次看到它时，你可以忽略大部分信息。
然后，随着你学习它的工作原理，你会随着时间的推移捕捉到更多的模式。

```
-rw-r--r-- 1 root root     68 Aug 22 23:20 resolv.conf
lrwxrwxrwx 1 root root     13 Mar 14 20:24 rmt -> /usr/sbin/rmt
drwxr-xr-x 4 root root   4.0K Jul 20 14:51 security
drwxr-xr-x 2 root root   4.0K Jul 20 14:53 selinux
-rw-r----- 1 root shadow  501 Jul 20 14:44 shadow
-rw-r--r-- 1 root root    116 Jul 20 14:43 shells
drwxr-xr-x 2 root root   4.0K Jul 20 14:57 skel
-rw-r--r-- 1 root root      0 Jul 20 14:43 subgid
-rw-r--r-- 1 root root      0 Jul 20 14:43 subuid
```

**有目的地使用颜色。**
例如，你可能想要高亮一些文本以便用户注意到它，或使用红色表示错误。
不要过度使用——如果所有东西都是不同的颜色，那么颜色就没有意义，只会使阅读变得更困难。

**如果你的程序不在终端中或用户请求，禁用颜色。**
这些情况应该禁用颜色：

- `stdout` 或 `stderr` 不是交互式终端（TTY）。
  最好单独检查——如果你将 `stdout` 管道到另一个程序，在 `stderr` 上获得颜色仍然是有用的。
- `NO_COLOR` 环境变量被设置且不为空（无论其值是什么）。
- `TERM` 环境变量的值为 `dumb`。
- 用户传入了 `--no-color` 选项。
- 如果用户想要专门为你的程序禁用颜色，你可能还想添加一个 `MYAPP_NO_COLOR` 环境变量。

*延伸阅读：[no-color.org](https://no-color.org/)、[12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46)*

**如果 `stdout` 不是交互式终端，不显示任何动画。**
这将阻止进度条在 CI 日志输出中变成圣诞树。

**在能让事情更清晰的地方使用符号和 emoji。**
如果你需要区分几件事、吸引用户的注意力或只是增加一点个性，图片可能比文字更好。
但要小心——很容易过度使用，使你的程序看起来杂乱或感觉像玩具。

例如，[yubikey-agent](https://github.com/FiloSottile/yubikey-agent) 使用 emoji 为输出添加结构，这样它就不只是一堵文字墙，并用 ❌ 来吸引你对重要信息的注意：

```shell-session
$ yubikey-agent -setup
🔐 The PIN is up to 8 numbers, letters, or symbols. Not just numbers!
❌ The key will be lost if the PIN and PUK are locked after 3 incorrect tries.

Choose a new PIN/PUK:
Repeat the PIN/PUK:

🧪 Retriculating splines …

✅ Done! This YubiKey is secured and ready to go.
🤏 When the YubiKey blinks, touch it to authorize the login.

🔑 Here's your new shiny SSH public key:
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCEJ/
UwlHnUFXgENO3ifPZd8zoSKMxESxxot4tMgvfXjmRp5G3BGrAnonncE7Aj11pn3SSYgEcrrn2sMyLGpVS0=

💭 Remember: everything breaks, have a backup plan for when this YubiKey does.
```

**默认情况下，不要输出只有软件创建者才能理解的信息。**
如果一段输出只是帮助你（开发者）理解你的软件在做什么，它几乎肯定不应该默认显示给普通用户——只在详细模式下显示。

邀请外部人士和项目新手提供可用性反馈。
他们会帮助你看到你离代码太近而注意不到的重要问题。

**不要把 `stderr` 当作日志文件，至少不要默认这样做。**
不要打印日志级别标签（`ERR`、`WARN` 等）或无关的上下文信息，除非在详细模式下。

**如果你要输出大量文本，使用分页器（如 `less`）。**
例如，`git diff` 默认就是这样做的。
使用分页器可能容易出错，所以要小心实现，这样你就不会让用户体验变得更糟。
只有当 `stdin` 或 `stdout` 是交互式终端时才使用分页器。

`less` 的一组好的合理选项是 `less -FIRX`。
如果内容填满一个屏幕，这不会分页，搜索时忽略大小写，启用颜色和格式化，并在 `less` 退出时将内容留在屏幕上。

你的语言中可能有比管道到 `less` 更健壮的库。
例如，Python 中的 [pypager](https://github.com/prompt-toolkit/pypager)。

### 错误 {#errors}

查阅文档的最常见原因之一是修复错误。
如果你能把错误变成文档，那将为用户节省大量时间。

**捕获错误并为人类重写它们。**
如果你预期会发生错误，捕获它并重写错误消息使其有用。
把它想象成一场对话，用户做错了什么，程序正在引导他们走向正确的方向。
例如："无法写入 file.txt。你可能需要运行 'chmod +w file.txt' 使其可写。"

**信噪比至关重要。**
你产生的无关输出越多，用户就需要越长时间来弄清楚他们做错了什么。
如果你的程序产生多个相同类型的错误，考虑将它们分组在一个解释性标题下，而不是打印许多看起来相似的行。

**考虑用户会首先看哪里。**
把最重要的信息放在输出的末尾。
眼睛会被红色文本吸引，所以要有意图地、谨慎地使用它。

**如果有意外或无法解释的错误，提供调试和回溯信息，以及如何提交 bug 的说明。**
话虽如此，不要忘记信噪比：你不想用他们不理解的信息压倒用户。
考虑将调试日志写入文件而不是打印到终端。

**使提交 bug 报告变得轻而易举。**
你可以做的一件好事是提供一个 URL，并让它预填尽可能多的信息。

*延伸阅读：[Google: Writing Helpful Error Messages](https://developers.google.com/tech-writing/error-messages)、[Nielsen Norman Group: Error-Message Guidelines](https://www.nngroup.com/articles/error-message-guidelines)*

### 参数和标志 {#arguments-and-flags}

术语说明：

- *参数*，或 *args*，是命令的位置参数。
  例如，你提供给 `cp` 的文件路径就是 args。
  参数的顺序通常很重要：`cp foo bar` 和 `cp bar foo` 意思不同。
- *标志*是命名参数，用连字符和单字母名称（`-r`）或双连字符和多字母名称（`--recursive`）表示。
  它们可能包含也可能不包含用户指定的值（`--file foo.txt` 或 `--file=foo.txt`）。
  标志的顺序，一般来说，不影响程序语义。

**优先使用标志而非参数。**
这需要多打一点字，但让发生的事情更清楚。
它还使将来更容易修改你接受输入的方式。
有时使用参数时，不破坏现有行为或造成歧义就无法添加新输入。

*引用：[12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46)。*

**所有标志都要有完整长度的版本。**
例如，同时有 `-h` 和 `--help`。
在脚本中有完整版本是有用的，你想要详细和描述性，而且你不必到处查找标志的含义。

*引用：[GNU Coding Standards](https://www.gnu.org/prep/standards/html*node/Command*002dLine-Interfaces.html)。*

**只对常用标志使用单字母标志，**特别是在使用子命令时的顶级。
这样你就不会"污染"你的短标志命名空间，迫使你在将来添加标志时使用复杂的字母和大小写。

**对多个文件的简单操作，多个参数是可以的。**
例如，`rm file1.txt file2.txt file3.txt`。
这也使它与通配符一起工作：`rm *.txt`。

**如果你有两个或更多不同事物的参数，你可能做错了什么。**
例外是常见的主要操作，其中简洁性值得记忆。
例如，`cp <source> <destination>`。

*引用：[12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46)。*

**如果有标准，使用标准的标志名称。**
如果另一个常用命令使用某个标志名称，最好遵循那个现有模式。
这样，用户不必记住两个不同的选项（以及它适用于哪个命令），用户甚至可以在不查看帮助文本的情况下猜测选项。

以下是常用选项的列表：

- `-a`、`--all`：全部。
  例如，`ps`、`fetchmail`。
- `-d`、`--debug`：显示调试输出。
- `-f`、`--force`：强制。
  例如，`rm -f` 将强制删除文件，即使它认为没有权限这样做。
  这对于执行通常需要用户确认的破坏性操作的命令也很有用，但你想在脚本中强制执行那个破坏性操作。
- `--json`：显示 JSON 输出。
  参见[输出](#output)部分。
- `-h`、`--help`：帮助。
  这应该只意味着帮助。
  参见[帮助](#help)部分。
- `-n`、`--dry-run`：预演。
  不运行命令，但描述如果运行命令会发生的更改。例如，`rsync`、`git add`。
- `--no-input`：参见[交互性](#interactivity)部分。
- `-o`、`--output`：输出文件。
  例如，`sort`、`gcc`。
- `-p`、`--port`：端口。
  例如，`psql`、`ssh`。
- `-q`、`--quiet`：安静。
  显示更少的输出。
  这在为人类显示输出时特别有用，你可能想在脚本中运行时隐藏它。
- `-u`、`--user`：用户。
  例如，`ps`、`ssh`。
- `--version`：版本。
- `-v`：这通常可以表示 verbose 或 version。
  你可能想用 `-d` 表示 verbose，用这个表示 version，或者为了避免混淆什么都不用。

**使默认值对大多数用户来说是正确的。**
使事物可配置是好的，但大多数用户不会找到正确的标志并记得一直使用它（或为它创建别名）。
如果它不是默认值，你就是在为大多数用户使体验变得更糟。

例如，`ls` 有简洁的默认输出以优化脚本和其他历史原因，但如果今天设计它，它可能会默认为 `ls -lhF`。

**提示用户输入。**
如果用户没有传递参数或标志，提示它。
（另见：[交互性](#interactivity)）

**永远不要*要求*提示。**
总是提供一种通过标志或参数传递输入的方式。
如果 `stdin` 不是交互式终端，跳过提示，只要求那些标志/参数。

**在做任何危险的事情之前确认。**
一个常见的惯例是，如果是交互式运行，提示用户输入 `y` 或 `yes`，否则要求他们传递 `-f` 或 `--force`。

"危险"是一个主观术语，有不同级别的危险：

- **轻度：**小的、局部的更改，如删除一个文件。
  你可能想要提示确认，也可能不想。
  例如，如果用户明确运行一个名为"delete"之类的命令，你可能不需要询问。
- **中度：**更大的局部更改，如删除一个目录，删除某种远程资源的远程更改，或无法轻易撤销的复杂批量修改。
  你通常想在这里提示确认。
  考虑给用户一种方式来"预演"操作，这样他们可以在提交之前看到会发生什么。
- **严重：**删除复杂的东西，如整个远程应用程序或服务器。
  你不只是想在这里提示确认——你想使意外确认变得困难。
  考虑要求他们输入一些非平凡的东西，如他们要删除的东西的名称。
  让他们可以选择传递一个标志如 `--confirm="name-of-thing"`，这样它仍然可以脚本化。

考虑是否有非明显的方式意外销毁东西。
例如，想象一种情况，将配置文件中的一个数字从 10 改为 1 意味着 9 个东西将被隐式删除——这应该被认为是严重风险，应该难以意外做到。

**如果输入或输出是文件，支持 `-` 从 `stdin` 读取或写入 `stdout`。**
这让另一个命令的输出成为你的命令的输入，反之亦然，而不使用临时文件。
例如，`tar` 可以从 `stdin` 提取文件：

```
$ curl https://example.com/something.tar.gz | tar xvf -
```

**如果标志可以接受可选值，允许一个特殊词如"none"。**
例如，`ssh -F` 接受一个可选的替代 `ssh_config` 文件的文件名，而 `ssh -F none` 运行 SSH 不使用配置文件。不要只使用空白值——这会使参数是标志值还是参数变得模糊。

**如果可能，使参数、标志和子命令的顺序无关。**
很多 CLI，特别是那些有子命令的，对你可以在哪里放置各种参数有不成文的规则。
例如，一个命令可能有一个 `--foo` 标志，只有当你把它放在子命令之前才起作用：

```
mycmd --foo=1 subcmd
works

$ mycmd subcmd --foo=1
unknown flag: --foo
```

这对用户来说可能非常困惑——特别是考虑到用户在试图让命令工作时最常见的事情之一是按向上箭头获取上次调用，在末尾加上另一个选项，然后再次运行。
如果可能，尝试使两种形式等效，尽管你可能会遇到参数解析器的限制。

**不要直接从标志读取密钥。**
当命令接受密钥时，例如通过 `--password` 标志，标志值会将密钥泄露到 `ps` 输出中，可能还有 shell 历史。
而且，这种标志鼓励使用不安全的环境变量存储密钥。
（环境变量是不安全的，因为它们通常可以被其他用户读取，它们的值最终会进入调试日志等。）

考虑只通过文件接受敏感数据，例如通过 `--password-file` 标志，或通过 `stdin`。
`--password-file` 标志允许在各种上下文中谨慎地传递密钥。

（在 Bash 中可以通过使用 `--password $(< password.txt)` 将文件内容传递给标志。
这种方法有上面提到的同样的安全问题。
最好避免。）

### 交互性 {#interactivity}

**只有当 `stdin` 是交互式终端（TTY）时才使用提示或交互元素。**
这是一种相当可靠的方式来判断你是在将数据管道到命令还是在脚本中运行，在这种情况下提示不会工作，你应该抛出一个错误，告诉用户要传递什么标志。

**如果传入了 `--no-input`，不要提示或做任何交互式的事情。**
这允许用户有一个明确的方式来禁用命令中的所有提示。
如果命令需要输入，失败并告诉用户如何将信息作为标志传递。

**如果你在提示密码，不要在用户输入时打印它。**
这是通过在终端中关闭回显来完成的。
你的语言应该有这方面的辅助函数。

**让用户可以退出。**
明确如何退出。
（不要做 vim 做的那样。）
如果你的程序在网络 I/O 等上挂起，总是让 Ctrl-C 仍然工作。
如果它是程序执行的包装器，而 Ctrl-C 不能退出（SSH、tmux、telnet 等），明确如何做到这一点。
例如，SSH 允许使用 `~` 转义字符进行转义序列。

### 子命令 {#subcommands}

如果你有一个足够复杂的工具，你可以通过制作一组子命令来降低其复杂性。
如果你有几个非常密切相关的工具，你可以通过将它们组合成一个命令使它们更容易使用和发现（例如，RCS vs. Git）。

它们对共享东西很有用——全局标志、帮助文本、配置、存储机制。

**在子命令之间保持一致。**
对相同的东西使用相同的标志名称，有类似的输出格式等。

**对多级子命令使用一致的名称。**
如果一个复杂的软件有很多对象和可以对这些对象执行的操作，使用两级子命令是一种常见模式，其中一个是名词，一个是动词。
例如，`docker container create`。
在不同类型的对象之间使用一致的动词。

`noun verb` 或 `verb noun` 顺序都可以工作，但 `noun verb` 似乎更常见。

*延伸阅读：[User experience, CLIs, and breaking the world, by John Starich](https://uxdesign.cc/user-experience-clis-and-breaking-the-world-baed8709244f)。*

**不要有模糊或名称相似的命令。**
例如，有两个名为"update"和"upgrade"的子命令是相当令人困惑的。
你可能想使用不同的词，或用额外的词来消除歧义。

### 健壮性 {#robustness-guidelines}

**验证用户输入。**
在你的程序接受用户数据的每个地方，它最终都会收到错误的数据。
尽早检查并在任何坏事发生之前退出，并[使错误可理解](#errors)。

**响应比快更重要。**
在 100 毫秒内向用户打印一些东西。
如果你正在进行网络请求，在你做之前打印一些东西，这样它就不会挂起并看起来像坏了。

**如果某事需要很长时间，显示进度。**
如果你的程序有一段时间不显示输出，它会看起来像坏了。
一个好的转圈或进度指示器可以使程序看起来比实际更快。

Ubuntu 20.04 有一个很好的进度条，固定在终端底部。

<!-- (TK reproduce this as a code block or animated SVG) -->

如果进度条长时间停在一个地方，用户不会知道事情是否仍在发生或程序是否崩溃了。
显示估计剩余时间，或者甚至只是有一个动画组件，来向他们保证你仍在工作，这是好的。

有许多好的库用于生成进度条。
例如，Python 的 [tqdm](https://github.com/tqdm/tqdm)，Go 的 [schollz/progressbar](https://github.com/schollz/progressbar)，和 Node.js 的 [node-progress](https://github.com/visionmedia/node-progress)。

**在可能的地方并行做事，但要深思熟虑。**
在 shell 中报告进度已经很困难了；为并行进程做这件事难十倍。
确保它是健壮的，输出不会令人困惑地交错。
如果你可以使用库，就使用——这是你不想自己写的代码。
像 Python 的 [tqdm](https://github.com/tqdm/tqdm) 和 Go 的 [schollz/progressbar](https://github.com/schollz/progressbar) 这样的库原生支持多个进度条。

好处是它可能是一个巨大的可用性提升。
例如，`docker pull` 的多个进度条提供了对正在发生什么的关键洞察。

```
$ docker image pull ruby
Using default tag: latest
latest: Pulling from library/ruby
6c33745f49b4: Pull complete
ef072fc32a84: Extracting [================================================>  ]  7.569MB/7.812MB
c0afb8e68e0b: Download complete
d599c07d28e6: Download complete
f2ecc74db11a: Downloading [=======================>                           ]  89.11MB/192.3MB
3568445c8bf2: Download complete
b0efebc74f25: Downloading [===========================================>       ]  19.88MB/22.88MB
9cb1ba6838a0: Download complete
```

要注意的一件事是：当事情进展*顺利*时，在进度条后面隐藏日志使用户更容易理解正在发生什么，但如果有错误，确保你打印出日志。
否则，将很难调试。

**让事情超时。**
允许网络超时被配置，并有一个合理的默认值，这样它就不会永远挂起。

**使其可恢复。**
如果程序因为某些暂时性原因失败（例如，互联网连接断开），你应该能够按 `<up>` 和 `<enter>`，它应该从它离开的地方继续。

**使其仅崩溃。**
这是幂等性的下一步。
如果你可以避免在操作后需要做任何清理，或者你可以将该清理推迟到下次运行，你的程序可以在失败或中断时立即退出。
这使它既更健壮又更响应。

*引用：[Crash-only software: More than meets the eye](https://lwn.net/Articles/191059/)。*

**人们会误用你的程序。**
为此做好准备。
他们会把它包装在脚本中，在糟糕的互联网连接上使用它，同时运行它的多个实例，并在你没有测试过的环境中使用它，有你没有预料到的怪癖。
（你知道 macOS 文件系统是大小写不敏感但同时保留大小写的吗？）

### 面向未来 {#future-proofing}

在任何类型的软件中，接口不经过长期和有充分文档记录的弃用过程就不能改变是至关重要的。
子命令、参数、标志、配置文件、环境变量：这些都是接口，你承诺保持它们工作。
（[语义化版本控制](https://semver.org/)只能原谅这么多变化；如果你每个月都推出一个主版本号升级，那就没有意义了。）

**尽可能保持变更是增量式的。**
与其以向后不兼容的方式修改标志的行为，也许你可以添加一个新标志——只要它不会使接口太臃肿。
（另见：[优先使用标志而非参数](#arguments-and-flags)。）

**在做非增量式变更之前发出警告。**
最终，你会发现你无法避免破坏一个接口。
在你这样做之前，在程序本身中警告你的用户：当他们传递你要弃用的标志时，告诉他们它即将改变。
确保他们有办法今天就修改他们的用法以使其面向未来，并告诉他们怎么做。

如果可能的话，你应该检测他们何时已经改变了他们的用法，不再显示警告：现在当你最终推出变更时他们不会注意到任何东西。

**改变人类的输出通常是可以的。**
使接口易于使用的唯一方法是迭代它，如果输出被认为是接口，那么你就不能迭代它。
鼓励你的用户在脚本中使用 `--plain` 或 `--json` 来保持输出稳定（见[输出](#output)）。

**不要有万能子命令。**
如果你有一个可能是最常用的子命令，你可能会想让人们为了简洁而完全省略它。
例如，假设你有一个包装任意 shell 命令的 `run` 命令：

    $ mycmd run echo "hello world"

你可以做到这样，如果 `mycmd` 的第一个参数不是现有子命令的名称，你就假设用户是指 `run`，这样他们就可以只输入这个：

    $ mycmd echo "hello world"

然而，这有一个严重的缺点：现在你永远不能添加一个名为 `echo` 的子命令——或*任何东西*——而不冒险破坏现有用法。
如果有一个脚本使用 `mycmd echo`，在那个用户升级到你工具的新版本后，它会做完全不同的事情。

**不允许子命令的任意缩写。**
例如，假设你的命令有一个 `install` 子命令。
当你添加它时，你想为用户节省一些打字，所以你允许他们输入任何非歧义的前缀，如 `mycmd ins`，甚至只是 `mycmd i`，并让它成为 `mycmd install` 的别名。
现在你被困住了：你不能再添加任何以 `i` 开头的命令，因为有脚本假设 `i` 意味着 `install`。

别名没有什么问题——节省打字是好的——但它们应该是显式的并保持稳定。

**不要创建"定时炸弹"。**
想象 20 年后。
你的命令还会像今天一样运行吗，还是因为互联网上某些外部依赖项已经改变或不再维护而停止工作？
最有可能在 20 年后不存在的服务器是你现在正在维护的那个。
（但也不要内置一个阻塞调用到 Google Analytics。）

### 信号和控制字符 {#signals}

**如果用户按下 Ctrl-C（INT 信号），尽快退出。**
在你开始清理之前立即说些什么。
为任何清理代码添加超时，这样它就不能永远挂起。

**如果用户在可能需要很长时间的清理操作期间按下 Ctrl-C，跳过它们。**
告诉用户当他们再次按下 Ctrl-C 时会发生什么，以防它是破坏性操作。

例如，当退出 Docker Compose 时，你可以第二次按 Ctrl-C 来强制你的容器立即停止，而不是优雅地关闭它们。

```
$  docker-compose up
…
^CGracefully stopping... (press Ctrl+C again to force)
```

你的程序应该预期在没有运行清理的情况下启动。
（见 [Crash-only software: More than meets the eye](https://lwn.net/Articles/191059/)。）

### 配置 {#configuration}

命令行工具有很多不同类型的配置，以及很多不同的提供方式（标志、环境变量、项目级配置文件）。
提供每条配置的最佳方式取决于几个因素，其中最重要的是*特定性*、*稳定性*和*复杂性*。

配置一般分为几类：

1.  可能在命令的每次调用之间变化。

    示例：

    - 设置调试输出的级别
    - 启用程序的安全模式或预演

    建议：**使用[标志](#arguments-and-flags)。**
    [环境变量](#environment-variables)也可能有用。

2.  通常在每次调用之间稳定，但不总是。
    可能在项目之间变化。
    在同一项目的不同用户之间肯定会变化。

    这种类型的配置通常特定于单个计算机。

    示例：

    - 为程序启动所需的项目提供非默认路径
    - 指定颜色应该如何或是否出现在输出中
    - 指定一个 HTTP 代理服务器来路由所有请求

    建议：**使用[标志](#arguments-and-flags)，可能也使用[环境变量](#environment-variables)。**
    用户可能想在他们的 shell 配置文件中设置变量以使其全局应用，或在 `.env` 中为特定项目设置。

    如果这种配置足够复杂，它可能需要一个自己的配置文件，但环境变量通常就足够了。

3.  在项目内稳定，对所有用户。

    这是属于版本控制的配置类型。
    像 `Makefile`、`package.json` 和 `docker-compose.yml` 这样的文件都是这方面的例子。

    建议：**使用命令特定的、版本控制的文件。**

**遵循 XDG 规范。**
2010 年，X Desktop Group，现在的 [freedesktop.org](https://freedesktop.org)，制定了一个关于配置文件可能位于的基本目录位置的规范。
一个目标是通过支持一个通用的 `~/.config` 文件夹来限制用户主目录中点文件的增殖。
XDG 基本目录规范（[完整规范](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)，[摘要](https://wiki.archlinux.org/index.php/XDG_Base_Directory#Specification)）被 yarn、fish、wireshark、emacs、neovim、tmux 和许多你知道和喜欢的其他项目支持。

**如果你自动修改不是你程序的配置，征求用户同意并告诉他们你在做什么。**
优先创建一个新的配置文件（例如 `/etc/cron.d/myapp`）而不是追加到现有的配置文件（例如 `/etc/crontab`）。
如果你必须追加或修改系统范围的配置文件，在该文件中使用带日期的注释来划分你的添加。

**按优先顺序应用配置参数。**
以下是配置参数的优先级，从高到低：

- 标志
- 正在运行的 shell 的环境变量
- 项目级配置（例如 `.env`）
- 用户级配置
- 系统范围配置

### 环境变量 {#environment-variables}

**环境变量用于*随命令运行上下文而变化*的行为。**
环境变量的"环境"是终端会话——命令运行的上下文。
所以，环境变量可能在每次命令运行时变化，或在一台机器上的终端会话之间变化，或在跨多台机器的一个项目的实例之间变化。

环境变量可能复制标志或配置参数的功能，或者它们可能与这些不同。
参见[配置](#configuration)以获取常见配置类型的分解和环境变量最合适的时机的建议。

**为了最大的可移植性，环境变量名称必须只包含大写字母、数字和下划线（并且不能以数字开头）。**
这意味着 `O_O` 和 `OWO` 是唯一同时也是有效环境变量名称的表情符号。

**目标是单行环境变量值。**
虽然多行值是可能的，但它们会造成 `env` 命令的可用性问题。

**避免占用广泛使用的名称。**
这里有一个 [POSIX 标准环境变量列表](https://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap08.html)。

**尽可能检查通用环境变量的配置值：**

- `NO_COLOR`，禁用颜色（见[输出](#output)）或 `FORCE_COLOR` 启用它并忽略检测逻辑
- `DEBUG`，启用更详细的输出
- `EDITOR`，如果你需要提示用户编辑文件或输入多于一行
- `HTTP_PROXY`、`HTTPS_PROXY`、`ALL_PROXY` 和 `NO_PROXY`，如果你要执行网络操作
  （你使用的 HTTP 库可能已经检查这些了。）
- `SHELL`，如果你需要打开用户首选 shell 的交互式会话
  （如果你需要执行 shell 脚本，使用特定的解释器如 `/bin/sh`）
- `TERM`、`TERMINFO` 和 `TERMCAP`，如果你要使用终端特定的转义序列
- `TMPDIR`，如果你要创建临时文件
- `HOME`，用于定位配置文件
- `PAGER`，如果你想自动分页输出
- `LINES` 和 `COLUMNS`，用于依赖于屏幕大小的输出（例如，表格）

**在适当的地方从 `.env` 读取环境变量。**
如果命令定义的环境变量在用户在特定目录中工作时不太可能改变，那么它也应该从本地 `.env` 文件读取它们，这样用户可以为不同的项目配置不同的设置，而不必每次都指定它们。
许多语言都有用于读取 `.env` 文件的库（[Rust](https://crates.io/crates/dotenv)、[Node](https://www.npmjs.com/package/dotenv)、[Ruby](https://github.com/bkeepers/dotenv)）。

**不要使用 `.env` 作为适当的[配置文件](#configuration)的替代品。**
`.env` 文件有很多限制：

- `.env` 文件通常不存储在源代码控制中
- （因此，存储在其中的任何配置都没有历史记录）
- 它只有一种数据类型：字符串
- 它容易被组织得很糟糕
- 它容易引入编码问题
- 它经常包含敏感的凭据和密钥材料，这些最好更安全地存储

如果看起来这些限制会妨碍可用性或安全性，那么专用的配置文件可能更合适。

**不要从环境变量读取密钥。**
虽然环境变量可能方便存储密钥，但它们已被证明太容易泄露：
- 导出的环境变量被发送到每个进程，从那里可以很容易地泄露到日志中或被窃取
- Shell 替换如 `curl -H "Authorization: Bearer $BEARER_TOKEN"` 将泄露到全局可读的进程状态中。
  （cURL 提供了 `-H @filename` 替代方案，用于从文件读取敏感头。）
- Docker 容器环境变量可以被任何有 Docker 守护进程访问权限的人通过 `docker inspect` 查看
- systemd 单元中的环境变量可以通过 `systemctl show` 全局读取

密钥只应该通过凭据文件、管道、`AF_UNIX` 套接字、密钥管理服务或其他 IPC 机制接受。

### 命名 {#naming}

> "注意对缩写的痴迷和对大写字母的回避；[Unix] 是由对他们来说重复性压力障碍就像矿工的黑肺病一样的人发明的系统。
> 长名字被磨损成三个字母的残块，就像被河流磨平的石头。"
> — Neal Stephenson，*[In the Beginning was the Command Line](https://web.stanford.edu/class/cs81n/command.txt)*

你的程序名称在 CLI 上特别重要：你的用户会一直输入它，它需要容易记住和输入。

**使它成为一个简单、容易记住的词。**
但不要太通用，否则你会踩到其他命令的脚趾头并让用户困惑。
例如，ImageMagick 和 Windows 都使用了命令 `convert`。

**只使用小写字母，如果真的需要就用破折号。**
`curl` 是一个好名字，`DownloadURL` 不是。

**保持简短。**
用户会一直输入它。
不要把它做得*太*短：最短的命令最好保留给一直使用的常见实用程序，如 `cd`、`ls`、`ps`。

**使它容易输入。**
如果你期望人们整天输入你的命令名，让他们的手轻松一点。

一个真实的例子：在 Docker Compose 成为 `docker compose` 之前很久，它是 [`plum`](https://github.com/aanand/fig/blob/0eb7d308615bae1ad4be1ca5112ac7b6b6cbfbaf/setup.py#L26)。
这原来是一个如此尴尬的、单手跳跃的动作，以至于它立即被重命名为 [`fig`](https://github.com/aanand/fig/commit/0cafdc9c6c19dab2ef2795979dc8b2f48f623379)，它——除了更短之外——流畅得多。

*延伸阅读：[The Poetics of CLI Command Names](https://smallstep.com/blog/the-poetics-of-cli-command-names/)*

### 分发 {#distribution}

**如果可能，作为单个二进制文件分发。**
如果你的语言默认不编译成二进制可执行文件，看看它是否有像 [PyInstaller](https://www.pyinstaller.org/) 这样的东西。
如果你真的不能作为单个二进制文件分发，使用平台的原生包安装程序，这样你就不会在磁盘上散布无法轻易删除的东西。
轻踏用户的计算机。

如果你正在制作语言特定的工具，如代码检查器，那么这条规则不适用——可以安全地假设用户的计算机上安装了该语言的解释器。

**使它容易卸载。**
如果需要说明，把它们放在安装说明的底部——人们想要卸载软件最常见的时机之一就是在安装之后。

### 分析 {#analytics}

使用指标可以帮助了解用户如何使用你的程序，如何使其更好，以及在哪里集中精力。
但是，与网站不同，命令行用户期望控制自己的环境，当程序在后台做事而不告诉他们时会感到惊讶。

**未经同意不要发送使用或崩溃数据。**
用户会发现的，他们会很生气。
非常明确地说明你收集了什么，为什么收集，它有多匿名，你如何匿名化它，以及你保留多长时间。

理想情况下，询问用户是否想要贡献数据（"选择加入"）。
如果你选择默认这样做（"选择退出"），那么在你的网站上或首次运行时清楚地告诉用户，并使其容易禁用。

收集使用统计数据的项目示例：

- Angular.js 以功能优先级的名义[使用 Google Analytics 收集详细分析数据](https://angular.io/analytics)。
  你必须明确选择加入。
  如果你想在组织内跟踪 Angular 使用情况，你可以将跟踪 ID 更改为指向你自己的 Google Analytics 属性。
- Homebrew 将指标发送到 Google Analytics 并有[一个很好的 FAQ](https://docs.brew.sh/Analytics) 详细说明他们的做法。
- Next.js [收集匿名使用统计数据](https://nextjs.org/telemetry)，默认启用。

**考虑收集分析数据的替代方案。**

- 检测你的网页文档。
  如果你想知道人们如何使用你的 CLI 工具，围绕你想要最好理解的用例制作一组文档，看看它们随时间的表现如何。
  看看人们在你的文档中搜索什么。
- 检测你的下载。
  这可以是一个粗略的指标来了解使用情况和用户运行的操作系统。
- 与你的用户交谈。
  联系并询问人们如何使用你的工具。
  在你的文档和仓库中鼓励反馈和功能请求，并尝试从提交反馈的人那里获取更多上下文。

*延伸阅读：[Open Source Metrics](https://opensource.guide/metrics/)*

## 延伸阅读 {#further-reading}

- [The Unix Programming Environment](https://en.wikipedia.org/wiki/The_Unix_Programming_Environment), Brian W. Kernighan and Rob Pike
- [POSIX Utility Conventions](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html)
- [Program Behavior for All Programs](https://www.gnu.org/prep/standards/html_node/Program-Behavior.html), GNU Coding Standards
- [12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46), Jeff Dickey
- [CLI Style Guide](https://devcenter.heroku.com/articles/cli-style-guide), Heroku
