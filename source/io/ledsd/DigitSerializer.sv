module DigitSerializer (
    input logic clk,
    input logic reset_n,
    input logic od,
    input logic[15:0] data,
    output logic fill,
    output logic ledsd_bl,
    output logic ledsd_ds,
    output logic ledsd_shcp,
    output logic ledsd_stcp
);

    // shcp频率受限
    // 8分频 * 16移位周期，50MHz / 8 = 6.25MHz
    // 8 * 16 = 2^7
    logic[6:0] counter;

    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == 1'b0)
            counter <= 7'd0;
        else
            counter <= counter + 1'd1;

    logic[2:0] subcycle;
    logic[3:0] shiftcycle;

    assign subcycle = counter[2:0];
    assign shiftcycle = counter[6:3];

    // 输出移位

    logic[15:0] output_buffer;
    logic[15:0] output_next;

    assign output_next =
        (shiftcycle == 4'b1111) ? data : {output_buffer[14:0], 1'b0};
    assign fill = counter == 7'b1111111;

    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == 1'b0)
            output_buffer <= 16'd0;
        else if (subcycle == 3'b111)
            output_buffer <= output_next;

    // 输出波形产生

    assign ledsd_bl = od;
    assign ledsd_ds = output_buffer[15];

    assign ledsd_shcp = subcycle == 3'd1;
    assign ledsd_stcp = subcycle == 3'd2 && shiftcycle == 4'd15;

endmodule
