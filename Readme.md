# 流影探针 Docker 镜像

[Abyssal-Fish-Technology/ly_probe](https://github.com/Abyssal-Fish-Technology/ly_probe)

```shell
docker build -t nickdlk/lyprobe .
```

## Environment

新增Environment 名称为 Build

添加Secret 

DOCKERHUB_USERNAME: dockerhub 用户名

DOCKERHUB_PASSWORD: dockerhub 密码

[Using secrets in GitHub Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)

## Docker
Docker hub ：https://hub.docker.com/r/nickdlk/lyprobe

Github Container ：https://github.com/nickdlkk/lyprobe-docker/pkgs/container/lyprobe-docker

# Usage

## lyprobe 命令行参数说明
| 参数 | 描述 |
|-------------------------------|------------------------------------------------------------------------------------------|
| -n <host:port|none> | NetFlow 收集器的地址。可以使用多个 -n 标志定义多个收集器。 |
| -i <interface|dump file> | 捕获数据包的接口名称或 .pcap 文件（仅用于调试）。 |
| -t <lifetime timeout> | 指定流的最大生命周期（秒）[默认=120]。 |
| -d <idle timeout> | 指定流的最大空闲生命周期（秒）[默认=30]。 |
| -l <queue timeout> | 指定过期流（在交付前排队）被发出的时间[默认=30]。 |
| -s <scan cycle> | 指定过期流被发出的频率（秒）[默认=30]。 |
| -N | 每次扫描时重建哈希。对于生成与 NetFlow 收集器相同的流非常有用。 |
| -p <aggregation> | 指定流聚合级别：<VLAN Id>/<协议>/<IP>/<端口>/<TOS>/<AS>。 |
| -f <filter> | 捕获数据包的 BPF 过滤器[默认=无过滤器]。 |
| -a | 如果定义了多个收集器，则此选项允许将所有流发送到所有收集器。 |
| -b <level> | 详细输出级别：0 - 无详细日志，1 - 限制日志（流量统计），2 - 完全详细日志。 |
| -G | 以守护进程模式启动。 |
| -O <# threads> | 数据包获取线程的数量[默认=2]。 |
| -P <path> | 存储转储文件的目录。 |
| -F <dump timeout> | 转储文件的转储频率（秒）。默认：60。 |
| -D <format> | 流的保存格式：b（原始/未压缩流），t（文本流）。 |
| -u <in dev idx> | 在发出的流中使用的输入设备的索引（传入流量）。默认值为 0。 |
| -Q <out dev idx> | 在发出的流中使用的输出设备的索引（传出流量）。默认值为 0。 |
| -v | 打印程序版本。 |
| -w <hash size> | 流哈希大小[默认=32768]。 |
| -e <flow delay> | 两次流导出之间的延迟（毫秒）[默认=1]。 |
| -B <packet count> | 在 -e 延迟之前发送的包数[默认=1]。 |
| -z <min flow size> | 最小 TCP 流大小（字节）。如果 TCP 流短于指定大小，则不会发出流[默认=无限制]。 |
| -M <max num flows> | 活动流的最大数量。对于限制内存或 CPU 分配非常有用[默认=4294967295]。 |
| -R <payload Len> | 指定最大有效负载长度[默认=0 字节]。 |
| -x <payload policy> | 指定最大有效负载导出策略。格式：TCP:UDP:ICMP:OTHER。 |
| -E <engine> | 指定引擎类型和 ID。格式为 engineType:engineId。[默认=0:0]。 |
| -m <min # flows> | 每个数据包的最小流数，除非过期流排队太久（见 -l）[默认=30]。 |
| -q <host:port> | 指定流发送者的地址:端口。 |
| -S <pkt rate>:<flow rate> | 数据包捕获采样率和流采样率。 |
| -A <AS list> | 包含已知 AS 的 GeoIP 文件。 |
| -c | 所有本地网络外的 IPv4 主机将被设置为 0.0.0.0。 |
| -r | 假定所有流量朝向本地网络（-L 必须在 -r 之前指定）。 |
| -1 <MAC>@<ifIdx> | 流源 MAC 地址。 |
| -2 <number> | 捕获指定数量的数据包并退出（仅用于调试）。 |
| -3 <port> | NetFlow/sFlow 收集器的端口。 |
| -4 <CPU/Core Id> | 将此进程绑定到指定的 CPU/Core。 |
| -5 | 计算隧道流量而不是外部封装。 |
| -6 | 以非混杂模式捕获数据包。 |
| -9 <path> | 定期将流量统计信息转储到指定文件。 |
| --black-list <networks> | 黑名单中的所有 IPv4 主机将被丢弃。 |
| --pcap-file-list <filename> | 指定包含 pcap 文件列表的文件名。 |
| --csv-separator <separator> | 指定文本文件的分隔符（见 -P）。默认是 '|'（管道）。 |
| --bi-directional | 强制流为双向。此选项不支持 NetFlow V5。 |
| --account-l2 | NetFlow 仅计算 IP 流量，而不计算 L2 头。 |
| --dump-metadata <file> | 将流元数据转储到指定文件并退出。 |

## docker运行参考

`ls /sys/class/net` 查看网络接口 -i 对应网络接口

需要用privilege和host的网络模式；

-n 对应的ip和端口需要在系统配置的采集节点中新增，对应IP和配置的端口

```
docker run -itd --privileged --name lyprobe --net=host nickdlk/lyprobe -T %IPV4_SRC_ADDR %IPV4_DST_ADDR %IN_PKTS %IN_BYTES %FIRST_SWITCHED %LAST_SWITCHED %L4_SRC_PORT %L4_DST_PORT %TCP_FLAGS %PROTOCOL %SRC_TOS %DNS_REQ_DOMAIN %DNS_REQ_TYPE %HTTP_URL %HTTP_REQ_METHOD %HTTP_HOST %HTTP_MIME %HTTP_RET_CODE %HTTP_USER_AGENT %THREAT_TYPE %THREAT_NAME %THREAT_VERS %ICMP_DATA %ICMP_SEQ_NUM %ICMP_PAYLOAD_LEN %THREAT_TIME -n 192.168.1.2:9997 -e 0 -w 32768 -k 1 -K /data/cap/3 -i ens192
```