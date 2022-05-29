module BcdDecoder (
    input logic[3:0] bcd,
    input logic led_seg_h_n,
    output logic[7:0] digit_n
);

    logic[7:1] digit_high;

    always_comb
        case (bcd)
            4'h0: digit_high = 7'b0000001;
            4'h1: digit_high = 7'b1001111;
            4'h2: digit_high = 7'b0010010;
            4'h3: digit_high = 7'b0000110;
            4'h4: digit_high = 7'b1001100;
            4'h5: digit_high = 7'b0100100;
            4'h6: digit_high = 7'b0100000;
            4'h7: digit_high = 7'b0001111;
            4'h8: digit_high = 7'b0000000;
            4'h9: digit_high = 7'b0000100;
            default: digit_high = 7'b1111111;
        endcase

    assign digit_n = {digit_high, led_seg_h_n};

endmodule
