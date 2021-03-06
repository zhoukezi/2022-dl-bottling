# 所用器材

使用野火征途Mini开发板，核心芯片为Altera EP4CE10F17C8N，实验中使用的外围设备包括5个低有效机械按键（其中1个用于复位信号）4个低有效蓝色LED和一个6位共阴极数码管，板载时钟频率为50MHz。

为减少引脚数，芯片发出的控制信号为串行信号，通过两片级联74HC595转换为并行信号后送至数码管，同时数码管的段选择信号在位间复用，每位还受位选择信号控制，使用时依次选择各位并送出该位下的段选择信号，若切换频率足够高，则视觉上表现为数码管各位同时显示。

[原理图](./doc/board-design.pdf)的第8页给出了LED部分、机械按键部分和蜂鸣器部分的原理图，第10页给出了数码管和74HC595部分的原理图。

# 外围IO

根元件接受3组输入信号，产生3组输x信号。`clk`作为全局时钟。`reset_n`作为低有效全局复位信号。`key_n[4:1]`为四个机械按键的输入。`led_n[4:1]`是控制LED的信号。`ledsd_bl`、`ledsd_ds`、`ledsd_shcp`、`ledsd_stcp`是控制数码管的串行信号。`buzzer`是控制蜂鸣器的信号。

机械按键输入被连接到`PulseKey`模块，该模块消除按键信号抖动，并将低有效电平信号转化为长1时钟的正脉冲，在按键按下时发出。

`SettingCounters`模块记录当前的设定值。该模块接受按键2和3的输入，分别用于增加当前计数器和将计数器归零。该模块还接受选择信号，以选择要修改的计数器，以及使能信号，以拒绝在工作时修改设定。将该模块独立于核心之外是最初考虑到可能要迁移到TEC-8试验台，并使用电平开关进行设定。

`Divider`模块对时钟分频以产生药片脉冲信号和显示电平信号。

`BcdDecoder`将4位BCD输入译码为数码管显示信号。译码器将无效编码译码为无显示。

`DigitDisplay`接受48位输入作为6个七段数码管的显示信号和低有效输出使能信号`od`，并输出控制数码管的四个串行信号。

`Buzzer`接受一个使能信号，并输出蜂鸣器控制信号`buzzer`。

一个直接位于根元件的组合逻辑将工作状态和选择状态转换为LED输出。

[整体设计](./doc/rtl-full.pdf)

# 核心元件

核心元件`BottlingCore`实现平台无关的逻辑。该元件接受设定信号、药片脉冲、显示电平和选择切换信号，输出3位BCD数字、工作状态和选择状态信号。

`WorkingCounters`接受两个设定值、使能信号和药片脉冲，输出总数、药瓶数和药片数三个工作量，还输出一个信号指示是否已完成工作。

`StatusController`接受转换工作状态和转换选择状态信号，输出5位独热选择信号指示当前选中的量，还输出一位信号指示是否处于工作状态。

`DisplayController`输入选择信号、工作状态信号、显示电平信号和5个状态量，根据当前选择输出对应的3位BCD数字，并控制显示闪烁。

[核心设计](./doc/rtl-core.pdf)

# 计数器

`BcdAdder`实现1位（4比特）BCD码全加器。

`BcdCounterN`实现N位BCD码计数器。该元件除一般计数器的输入和输出信号外，还接受一个模值，以允许可变模值计数。

# 工作周期

- 开始时，芯片处于设定状态
  * 用按键4选择设定瓶数和设定单瓶药片数
  * 用按键2将选择的数字加1
  * 用按键3将数字清零
  * 数码管闪烁
- 按按键1，芯片进入工作状态
  * 用按键4循环选择总药片数、已装瓶数、单瓶已装药片数、设定瓶数和设定单瓶药片数
  * 不可更改设定
- 装瓶完成时，芯片进入工作完成状态
  * LED 4亮起
  * 蜂鸣器发出警报
  * 用按键1返回设定状态

选择总药片数、瓶数、单瓶药片数时，LED 3、2、1分别亮起。选择设定量时，LED闪烁。选择工作量时，LED常亮。

# 代码结构

- `project/quartus/`目录包含Quartus工程文件，所用版本为Quartus Prime 21.1.0；
- `source/`目录包含源代码：
  * `source/core/`包含核心逻辑，即计数器和状态控制逻辑；
  * `source/io/`包含外围设备相关模块，包括蜂鸣器控制、机械按键消抖和脉冲发生、显示数码管控制、显示译码等。

# 问题及解决

进行测试时，曾发现硬件行为与模拟行为不一致。后发现不正确的使用了阻塞赋值，模拟器模拟了阻塞赋值行为，但综合器生成的硬件设计并未严格遵循这一行为，原因未知。改正后问题消失。因此，在描述硬件设计时，要注意区分阻塞和非阻塞赋值，还应注意模拟器和综合器可能有不一致的行为。

在设计硬件时，因EP4CE10F17C8N资源较丰富，并未特别优化设计。需要进行分频的硬件多使用独立的分频计数器。这可能增加了资源开销，并且导致硬件设计难以适配较低端芯片。为了节约资源，可以合并部分分频计数器。还可以简化部分复杂逻辑设计，但可能导致功能受限。
