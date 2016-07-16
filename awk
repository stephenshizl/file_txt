WD=`pwd`
0 ACTION=$1
1 PRODUCT=$2	sabresd_6dq
2 VARIANT=$3	eng
3 PACKAGE=$4
make build sabresd_6dq eng

HOST_PROCESSOR=`cat /proc/cpuinfo | grep processor | wc -l | awk '{print "-j"$1}'`
PARAM=($HOST_PROCESSOR)
PARAM+=(bootimage)
source $WD/build/envsetup.sh && lunch $PRODUCT-$VARIANT && make "${PARAM[@]}" 2>&1 | tee boot_$PRODUCT-$VARIANT.log && echo "Build Done!"


简单来说awk就是把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行各种分析处理


awk '{pattern + action}' {filenames}

尽管操作可能会很复杂，但语法总是这样，其中 pattern 表示 AWK 在数据中查找的内容，而 action 是在找到匹配内容时所执行的一系列命令。花括号（{}）不需要在程序中始终出现，但它们用于根据特定的模式对一系列指令进行分组。 pattern就是要表示的正则表达式，用斜杠括起来。

awk语言的最基本功能是在文件或者字符串中基于指定规则浏览和抽取信息，awk抽取信息后，才能进行其他文本操作。完整的awk脚本通常用来格式化文本文件中的信息。

通常，awk是以文件的一行为处理单位的。awk每接收文件的一行，然后执行相应的命令，来处理文本。

假设last -n 5的输出如下

[root@www ~]# last -n 5 <==仅取出前五行
root     pts/1   192.168.1.100  Tue Feb 10 11:21   still logged in
root     pts/1   192.168.1.100  Tue Feb 10 00:46 - 02:28  (01:41)
root     pts/1   192.168.1.100  Mon Feb  9 11:41 - 18:30  (06:48)
dmtsai   pts/1   192.168.1.100  Mon Feb  9 11:41 - 11:41  (00:00)
root     tty1                   Fri Sep  5 14:09 - 14:10  (00:01)

如果只是显示最近登录的5个帐号

#last -n 5 | awk  '{print $1}'
root
root
root
dmtsai
root

awk工作流程是这样的：读入有'\n'换行符分割的一条记录，然后将记录按指定的域分隔符划分域，填充域，$0则表示所有域,$1表示第一个域,$n表示第n个域。默认域分隔符是"空白键" 或 "[tab]键",所以$1表示登录用户，$3表示登录用户ip,以此类推。

 

如果只是显示/etc/passwd的账户

#cat /etc/passwd |awk  -F ':'  '{print $1}'  
root
daemon
bin
sys

这种是awk+action的示例，每行都会执行action{print $1}。

-F指定域分隔符为':'。