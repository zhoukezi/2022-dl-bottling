# 所用器材

使用野火征途Mini开发板，核心芯片为Altera EP4CE10F17C8N，实验中使用的外围设备包括5个低有效机械按键（其中1个用于复位信号）和一个6位共阴极数码管。

为减少引脚数，芯片发出的控制信号为串行信号，通过两片级联74HC595转换为并行信号后送至数码管，同时数码管的段选择信号在位间复用，每位还受位选择信号控制，使用时依次选择各位并送出该位下的段选择信号，若切换频率足够高，则视觉上表现为数码管各位同时显示。

# 代码结构

- `project/quartus/`目录包含Quartus工程文件，所用版本为Quartus Prime 21.1.0；
- `source/`目录包含源代码：
  * `source/core/`包含核心逻辑，即计数器和状态控制逻辑；
  * `source/io/`包含外围设备相关模块，包括蜂鸣器控制、机械按键消抖和脉冲发生、显示数码管控制、显示译码等。
