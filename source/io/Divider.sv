// 分频器，通过全局时钟生成显示闪烁信号（电平）和模拟药片信号（脉冲）
module Divider (
    input logic clk,
    input logic reset_n,
    output logic display_flicker,
    output logic pill_pulse
);

    // TODO(migrate) 50MHz => 5kHz
    // 全局时钟50MHz，10^8分频
    logic[26:0] counter;

    logic carry;

    // 计数
    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == 1'b0)
            counter <= 27'd0;
        else
            if (carry)
                counter <= 27'd0;
            else
                counter <= counter + 1'b1;

    assign carry = counter == (27'd100_000_000 - 27'd1);

    // 显示闪烁信号：0.5Hz方波
    assign display_flicker = counter < (27'd100_000_000 / 27'd2);

    // 模拟药片信号：0.5Hz单周期正脉冲
    assign pill_pulse = carry;

endmodule
