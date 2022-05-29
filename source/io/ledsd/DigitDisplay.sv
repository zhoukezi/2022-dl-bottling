module DigitDisplay (
    input logic clk,
    input logic reset_n,
    input logic od,
    input logic[47:0] digit_n,
    output logic ledsd_bl,
    output logic ledsd_ds,
    output logic ledsd_shcp,
    output logic ledsd_stcp
);

    logic[7:0] current_digit_n;
    logic[5:0] digit_en;
    logic fill;

    DigitSerializer serializer(
        .clk(clk),
        .reset_n(reset_n),
        .od(od | !reset_n),
        .data({
            2'b00,
            digit_en[0],
            digit_en[1],
            digit_en[2],
            digit_en[3],
            digit_en[4],
            digit_en[5],
            current_digit_n[0],
            current_digit_n[1],
            current_digit_n[2],
            current_digit_n[3],
            current_digit_n[4],
            current_digit_n[5],
            current_digit_n[6],
            current_digit_n[7]
        }),
        .fill(fill),
        .ledsd_bl(ledsd_bl),
        .ledsd_ds(ledsd_ds),
        .ledsd_shcp(ledsd_shcp),
        .ledsd_stcp(ledsd_stcp)
    );

    // 6状态环形计数器
    logic[5:0] counter;

    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == 1'b0)
            counter <= 6'b000_001;
        else if (fill == 1'b1)
            counter <= {counter[4:0], counter[5]};

    DigitSelector selector(
        .digit_n(digit_n),
        .sel(counter),
        .out(current_digit_n)
    );

    assign digit_en = counter;

endmodule
